import pytest_asyncio
from sqlalchemy.ext.asyncio import create_async_engine, AsyncSession
from sqlalchemy.orm import sessionmaker
from testcontainers.postgres import PostgresContainer
import pytest
from httpx import AsyncClient, ASGITransport
from sqlmodel import SQLModel

# Import your FastAPI app
from app.main import app
from app.database.session import get_session


@pytest.fixture(scope="session")
def postgres_container():
    """Starts a Postgres container for the test session."""
    with PostgresContainer("postgres:15-alpine", driver="psycopg") as postgres:
        yield postgres


@pytest_asyncio.fixture(scope="session")
async def db_engine(postgres_container: PostgresContainer):
    """Provides a database engine connected to the test container."""
    # The connection URL from testcontainers is synchronous, we make it async
    async_db_url = postgres_container.get_connection_url().replace("postgresql://", "postgresql+psycopg://")
    engine = create_async_engine(async_db_url)
    yield engine
    await engine.dispose()


@pytest_asyncio.fixture(scope="function")
async def db_session(db_engine):
    """
    Provides a clean, transactional session for each test function.
    All tables are dropped and recreated before each test.
    """
    # Create all tables for each test, ensuring a clean slate
    async with db_engine.begin() as conn:
        await conn.run_sync(SQLModel.metadata.drop_all)
        await conn.run_sync(SQLModel.metadata.create_all)

    # Begin a transaction for the test
    connection = await db_engine.connect()
    transaction = await connection.begin()
    
    SessionLocal = sessionmaker(
        class_=AsyncSession,
        bind=connection,
        expire_on_commit=False,
    )
    session = SessionLocal()
    
    yield session
    
    # Clean up the session and roll back the transaction
    await session.close()
    if transaction.is_active:
        await transaction.rollback()
    await connection.close()


@pytest_asyncio.fixture(scope="function")
async def test_client(db_session: AsyncSession) -> AsyncClient:
    """
    Creates an AsyncClient for API testing, overriding the `get_session` 
    dependency to use the isolated test database session.
    """
    def override_get_session():
        yield db_session

    app.dependency_overrides[get_session] = override_get_session
    
    async with AsyncClient(transport=ASGITransport(app=app), base_url="http://test") as client:
        yield client
    
    # Clean up dependency overrides
    app.dependency_overrides.clear()