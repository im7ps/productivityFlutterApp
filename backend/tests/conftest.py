import pytest
import os
import sys
import asyncio
from typing import AsyncGenerator, Generator, Optional

import pytest_asyncio
from sqlalchemy.ext.asyncio import create_async_engine, AsyncSession, AsyncEngine
from sqlalchemy.orm import sessionmaker
from testcontainers.postgres import PostgresContainer
from testcontainers.core.wait_strategies import LogMessageWaitStrategy
from httpx import AsyncClient, ASGITransport
from sqlmodel import SQLModel, select # Added select
from app.models.user import User # Added for test_user fixture

# Import application components
from app.main import app
from app.database.session import get_session
from app.core.rate_limit import limiter
from app.core import security # Imported for monkeypatching
import uuid

# --- ENVIRONMENT CONFIGURATION ---

@pytest.fixture(scope="session", autouse=True)
def enforce_test_environment_variables():
    """
    Sets critical environment variables to safe test values globally.
    This runs before any other fixture or test logic.
    """
    os.environ["SECRET_KEY"] = "test_secret_key_fixed_for_all_tests"
    os.environ["ALGORITHM"] = "HS256"
    os.environ["ACCESS_TOKEN_EXPIRE_MINUTES"] = "15"
    # Note: DATABASE_URL handling is done dynamically in the db_engine fixture.


@pytest.fixture(scope="session")
def event_loop_policy():
    """
    Sets the event loop policy. On Windows, uses WindowsSelectorEventLoopPolicy
    for compatibility with psycopg.
    """
    if sys.platform == "win32":
        return asyncio.WindowsSelectorEventLoopPolicy()
    return asyncio.get_event_loop_policy()


@pytest.fixture(scope="session", autouse=True)
def disable_rate_limiting():
    """Globally disables rate limiting to prevent 429 errors during testing."""
    limiter.enabled = False


@pytest.fixture(scope="session", autouse=True)
def security_settings(monkeypatch_session):
    """
    Forces security settings to known test values using monkeypatch.
    Uses a session-scoped monkeypatch (requires pytest-monkeypatch or custom fixture).
    Since default monkeypatch is function-scoped, we apply these manually or assume the env vars above cover it.
    The os.environ fixture above is actually sufficient for env-based config like Pydantic Settings.
    However, if code imports constants directly, we might need to patch the module.
    """
    # Patching module-level constants if they were imported before env vars were set
    monkeypatch_session.setattr(security, "SECRET_KEY", "test_secret_key_fixed_for_all_tests")
    monkeypatch_session.setattr(security, "ALGORITHM", "HS256")


# --- CUSTOM SESSION SCOPED MONKEYPATCH ---
@pytest.fixture(scope="session")
def monkeypatch_session():
    """
    Pytest's built-in monkeypatch is function-scoped. 
    This is a custom session-scoped monkeypatch fixture.
    """
    from _pytest.monkeypatch import MonkeyPatch
    mp = MonkeyPatch()
    yield mp
    mp.undo()


# --- HYBRID DATABASE INFRASTRUCTURE ---

@pytest.fixture(scope="session")
def postgres_container() -> Generator[Optional[PostgresContainer], None, None]:
    """
    Provides a PostgresContainer for local testing.
    Yields None if DATABASE_URL is set (e.g. CI/Docker), skipping container launch.
    """
    if os.environ.get("DATABASE_URL"):
        yield None
        return

    # Local fallback: Launch Testcontainer
    postgres = PostgresContainer("postgres:15-alpine", driver="psycopg")
    postgres.wait_for_waiting_strategy = LogMessageWaitStrategy(
        "database system is ready to accept connections", times=1
    )
    
    with postgres as container:
        yield container


@pytest_asyncio.fixture(scope="session")
async def db_engine(postgres_container: Optional[PostgresContainer]) -> AsyncGenerator[AsyncEngine, None]:
    """
    Creates the SQLAlchemy AsyncEngine.
    Selects the connection URL based on the environment (Hybrid Logic).
    """
    external_url = os.environ.get("DATABASE_URL")
    
    if external_url:
        # Use provided external DB (Docker Service / CI)
        url = external_url
    elif postgres_container:
        # Use local Testcontainer
        url = postgres_container.get_connection_url().replace("postgresql://", "postgresql+psycopg://")
    else:
        raise RuntimeError("No database configuration found (neither Testcontainers nor DATABASE_URL).")
    
    engine = create_async_engine(url, echo=False, future=True)
    
    # Initialize Schema
    async with engine.begin() as conn:
        await conn.run_sync(SQLModel.metadata.drop_all)
        await conn.run_sync(SQLModel.metadata.create_all)
        
    yield engine
    
    await engine.dispose()


# --- TRANSACTION MANAGEMENT (ISOLATION) ---

@pytest_asyncio.fixture(scope="function")
async def db_session(db_engine: AsyncEngine) -> AsyncGenerator[AsyncSession, None]:
    """
    Yields an AsyncSession wrapped in a NESTED TRANSACTION (SAVEPOINT).
    Rolls back at the end of every test to guarantee pristine state.
    """
    # Connect to the database
    connection = await db_engine.connect()
    
    # Begin a generic transaction
    trans = await connection.begin()
    
    # Begin a NESTED transaction (SAVEPOINT) for the test
    # This allows the test to commit/rollback its own inner transactions 
    # without affecting the outer transaction which we will rollback.
    nested = await connection.begin_nested()
    
    # Create the session bound to this specific connection
    SessionLocal = sessionmaker(
        bind=connection,
        class_=AsyncSession,
        expire_on_commit=False,
        autoflush=False,
    )

    async with SessionLocal() as session:
        yield session
        
        # In case the test code committed/rolled back the nested transaction,
        # we don't need to do anything as the outer 'trans' rollback covers it.
        # But if the session is still open, we close it.
    
    # Rollback the outer transaction to discard ALL changes (including committed nested ones)
    await trans.rollback()
    await connection.close()


# --- CLIENT API FIXTURE ---

@pytest_asyncio.fixture(scope="function")
async def test_client(db_session: AsyncSession) -> AsyncGenerator[AsyncClient, None]:
    """
    Yields an AsyncClient configured to use the isolated test db_session.
    """
    async def override_get_session():
        yield db_session

    app.dependency_overrides[get_session] = override_get_session
    
    async with AsyncClient(transport=ASGITransport(app=app), base_url="http://test") as client:
        yield client
    
    app.dependency_overrides.clear()


# --- AUTH HELPERS ---

@pytest.fixture
def auth_user_context(test_client: AsyncClient):
    """
    A helper fixture factory that creates a new user, registers them,
    and returns their auth headers.
    Moved from test_category_access.py to be globally available.
    """
    async def _create_user_and_login(username_suffix: str) -> dict:
        user_credentials = {
            "username": f"user{username_suffix}{uuid.uuid4().hex[:4]}",
            "email": f"user_{username_suffix}_{uuid.uuid4().hex[:4]}@example.com",
            "password": "ValidPassword123!",
        }
        
        # Register
        reg_response = await test_client.post("/api/v1/auth/register", json=user_credentials)
        assert reg_response.status_code == 201, f"Registration failed: {reg_response.text}"
        user_id = reg_response.json()["id"]

        # Login
        login_payload = {
            "username": user_credentials["username"],
            "password": user_credentials["password"],
        }
        log_response = await test_client.post("/api/v1/auth/login", data=login_payload)
        assert log_response.status_code == 200, f"Login failed: {log_response.text}"
        token = log_response.json()["access_token"]
        
        return {
            "headers": {"Authorization": f"Bearer {token}"},
            "user_id": user_id,
            "username": user_credentials["username"]
        }

    return _create_user_and_login


@pytest_asyncio.fixture(scope="function")
async def auth_token_data(auth_user_context: callable) -> dict:
    """
    Registers and logs in a user once per test, providing shared data for other fixtures.
    """
    return await auth_user_context("shared")


@pytest_asyncio.fixture(scope="function")
async def authenticated_client(
    test_client: AsyncClient,
    auth_token_data: dict,
) -> AsyncGenerator[AsyncClient, None]:
    """
    Provides an AsyncClient that is pre-authenticated with the shared user.
    """
    test_client.headers.update(auth_token_data["headers"])
    yield test_client
    test_client.headers.clear() # Clear headers after test to avoid side effects


@pytest_asyncio.fixture(scope="function")
async def test_user(
    auth_token_data: dict,
    db_session: AsyncSession,
) -> User:
    """
    Provides the User object for the authenticated user shared across fixtures.
    """
    # Corrected: use session.execute and .scalars().first() for async session
    result = await db_session.execute(select(User).where(User.id == auth_token_data["user_id"]))
    user = result.scalars().first()
    assert user is not None
    return user


@pytest_asyncio.fixture(scope="function", autouse=True)
async def initial_dimensions(db_session: AsyncSession):
    """
    Populates the database with initial Dimension data required for consultant proposals.
    """
    from app.models.dimension import Dimension # Import Dimension here to avoid circular dependencies if used globally

    dimensions_to_add = [
        Dimension(id="dovere", name="Dovere", description="Tasks related to duties."),
        Dimension(id="passione", name="Passione", description="Tasks related to passions."),
        Dimension(id="energia", name="Energia", description="Tasks related to energy."),
        Dimension(id="relazioni", name="Relazioni", description="Tasks related to relationships."),
        Dimension(id="anima", name="Anima", description="Tasks related to soul/spiritual growth."),
    ]
    
    db_session.add_all(dimensions_to_add)
    await db_session.flush() # Ensure IDs are assigned
    
    yield # Allow tests to run
    
    # Dimensions will be rolled back by db_session's rollback
