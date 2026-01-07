import pytest
import os
import sys
import asyncio
from typing import AsyncGenerator, Generator

# --- CONFIGURAZIONE AMBIENTE ---
# --- GESTIONE EVENT LOOP POLICY (MODO MODERNO) ---
@pytest.fixture(scope="session")
def event_loop_policy():
    """
    Returns the event loop policy to be used by pytest-asyncio.
    Sets WindowsSelectorEventLoopPolicy on Windows for compatibility with psycopg.
    """
    if sys.platform == "win32":
        return asyncio.WindowsSelectorEventLoopPolicy()
    return asyncio.get_event_loop_policy()

# Set environment variables BEFORE importing the app
# Use a non-existent placeholder. 
# We intentionally use a format that satisfies SQLAlchemy/SQLModel but won't accidentally connect to a real DB.
os.environ["SECRET_KEY"] = "test_secret_key_for_users_of_this_project"
os.environ["DATABASE_URL"] = "postgresql+psycopg://placeholder:placeholder@localhost:5432/placeholder"

import pytest_asyncio
from sqlalchemy.ext.asyncio import create_async_engine, AsyncSession, AsyncEngine
from sqlalchemy.orm import sessionmaker
from testcontainers.postgres import PostgresContainer
from testcontainers.core.wait_strategies import LogMessageWaitStrategy
from httpx import AsyncClient, ASGITransport
from sqlmodel import SQLModel

# Import your FastAPI app
from app.main import app
from app.database.session import get_session
from app.core.rate_limit import limiter


# --- GLOBAL TEST CONFIGURATION ---
@pytest.fixture(scope="session", autouse=True)
def disable_rate_limiting():
    """
    Globally disables rate limiting for the entire test session.
    This prevents 429 errors during rapid-fire integration tests.
    """
    limiter.enabled = False


# --- INFRASTRUTTURA TESTCONTAINERS ---
@pytest.fixture(scope="session")
def postgres_container() -> Generator[PostgresContainer, None, None]:
    """
    Starts a Postgres container for the test session.
    """
    # Nota: driver="psycopg" qui è opzionale per testcontainers, ma utile per chiarezza.
    postgres = PostgresContainer("postgres:15-alpine", driver="psycopg")
    
    # La tua strategia custom è ottima per evitare race conditions
    postgres.wait_for_waiting_strategy = LogMessageWaitStrategy(
        "database system is ready to accept connections", times=1
    )
    
    with postgres as container:
        yield container


# --- DATABASE SETUP ---
@pytest_asyncio.fixture(scope="session")
async def db_engine(postgres_container: PostgresContainer) -> AsyncGenerator[AsyncEngine, None]:
    """Provides a database engine connected to the test container."""
    
    # Assicuriamo che l'URL usi il driver asincrono corretto (psycopg 3)
    # connection_url example: postgresql+psycopg://user:pass@localhost:port/db
    async_db_url = postgres_container.get_connection_url().replace("postgresql://", "postgresql+psycopg://")
    
    engine = create_async_engine(async_db_url, echo=False, future=True)
    
    yield engine
    
    await engine.dispose()


@pytest_asyncio.fixture(scope="session")
async def setup_database(db_engine: AsyncEngine):
    """
    Set up the database schema once for the entire test session.
    All tables are dropped and recreated at the beginning of the session.
    """
    async with db_engine.begin() as conn:
        await conn.run_sync(SQLModel.metadata.drop_all)
        await conn.run_sync(SQLModel.metadata.create_all)
    yield


# --- SESSIONE TRANSAZIONALE (ROLLBACK) ---
@pytest_asyncio.fixture(scope="function")
async def db_session(db_engine: AsyncEngine, setup_database) -> AsyncGenerator[AsyncSession, None]:
    """
    Provides a clean, transactional session for each test function.
    Rolls back at the end to keep DB clean.
    """
    connection = await db_engine.connect()
    transaction = await connection.begin()
    
    SessionLocal = sessionmaker(
        bind=connection,
        class_=AsyncSession,
        expire_on_commit=False,
        autoflush=False, # Importante nei test per evitare scritture implicite indesiderate
    )
    
    async with SessionLocal() as session:
        yield session
        # Non serve commit, il rollback della transazione padre annulla tutto
    
    # Clean up
    if transaction.is_active:
        await transaction.rollback()
    await connection.close()


# --- CLIENT API ---
@pytest_asyncio.fixture(scope="function")
async def test_client(db_session: AsyncSession) -> AsyncGenerator[AsyncClient, None]:
    """
    Creates an AsyncClient for API testing, overriding the `get_session` 
    dependency to use the isolated test database session.
    """
    # Definiamo l'override come async generator per coerenza completa
    async def override_get_session():
        yield db_session

    app.dependency_overrides[get_session] = override_get_session
    
    async with AsyncClient(transport=ASGITransport(app=app), base_url="http://test") as client:
        yield client
    
    app.dependency_overrides.clear()

