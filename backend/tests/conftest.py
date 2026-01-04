import pytest_asyncio
from sqlalchemy.ext.asyncio import create_async_engine, AsyncSession
from sqlalchemy.orm import sessionmaker
from testcontainers.postgres import PostgresContainer
from alembic.config import Config
from alembic import command
import pytest
from sqlmodel import SQLModel

@pytest.fixture(scope="session")
def postgres_container():
    """
    Avvia il container una volta per tutta la sessione di test.
    """
    with PostgresContainer("postgres:15-alpine", driver="psycopg") as postgres:
        yield postgres

@pytest_asyncio.fixture(scope="session")
async def db_engine(postgres_container: PostgresContainer):
    """
    Applica le migrazioni al DB di test e fornisce un engine ASINCRONO.
    """
    # La parte di Alembic è sincrona e va eseguita prima
    sync_db_url = postgres_container.get_connection_url()
    alembic_cfg = Config("alembic.ini")
    alembic_cfg.set_main_option("sqlalchemy.url", sync_db_url)
    alembic_cfg.set_main_option("script_location", "alembic")
    command.upgrade(alembic_cfg, "head")

    # Ora creiamo l'engine ASINCRONO per i test, usando il dialetto corretto
    async_db_url = sync_db_url.replace("postgresql://", "postgresql+psycopg://")
    engine = create_async_engine(async_db_url)
    
    yield engine
    
    await engine.dispose()

@pytest_asyncio.fixture(scope="function")
async def db_session(db_engine):
    """
    Crea una transazione asincrona isolata per ogni test. 
    Esegue un ROLLBACK automatico alla fine.
    """
    connection = await db_engine.connect()
    transaction = await connection.begin()
    
    SessionLocal = sessionmaker(
        class_=AsyncSession, # Usiamo la AsyncSession standard di SQLAlchemy
        bind=connection,
        expire_on_commit=False,
    )
    session = SessionLocal()
    
    yield session
    
    await session.close()
    if transaction.is_active:
        await transaction.rollback()
    await connection.close()