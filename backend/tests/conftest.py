import pytest
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
from sqlmodel import SQLModel, Session as SQLModelSession
from testcontainers.postgres import PostgresContainer
from alembic.config import Config
from alembic import command
import os

@pytest.fixture(scope="session")
def postgres_container():
    """
    Avvia il container una volta per tutta la sessione di test.
    """
    # Usiamo un'immagine specifica. 
    # Suggerimento: aggiorna testcontainers con `pip install -U testcontainers`
    with PostgresContainer("postgres:15-alpine") as postgres:
        yield postgres

@pytest.fixture(scope="session")
def db_engine(postgres_container: PostgresContainer):
    """
    Applica le migrazioni al DB di test appena creato.
    """
    database_url = postgres_container.get_connection_url()
    engine = create_engine(database_url)
    
    # Configurazione programmatica di Alembic per puntare al container
    alembic_cfg = Config("alembic.ini") # Carica la config base dal file
    alembic_cfg.set_main_option("sqlalchemy.url", database_url)
    # Assicuriamo che lo script location sia corretto
    alembic_cfg.set_main_option("script_location", "alembic")

    # Esegue le migrazioni
    command.upgrade(alembic_cfg, "head")

    yield engine
    engine.dispose()

@pytest.fixture(scope="function")
def db_session(db_engine):
    """
    Crea una transazione isolata per ogni test. 
    ROLLBACK automatico alla fine.
    """
    connection = db_engine.connect()
    transaction = connection.begin()
    
    # Bind della sessione alla connessione specifica (non all'engine generico)
    SessionLocal = sessionmaker(
        class_=SQLModelSession, 
        autocommit=False, 
        autoflush=False, 
        bind=connection
    )
    session = SessionLocal()
    
    yield session
    
    session.close()
    # Se la transazione è ancora attiva (cioè non è stata invalidata da un errore
    # come IntegrityError), eseguiamo il rollback. Altrimenti, l'errore ha già
    # causato un rollback implicito e tentare di farlo di nuovo causa un warning.
    if transaction.is_active:
        transaction.rollback()
    connection.close()