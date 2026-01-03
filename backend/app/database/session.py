from sqlmodel import create_engine, Session, SQLModel
import os

# Recuperiamo l'URL del database dalle variabili d'ambiente definite in docker-compose
DATABASE_URL = os.getenv("DATABASE_URL")

# L'engine è il motore che gestisce le connessioni
engine = create_engine(DATABASE_URL, echo=True) # echo=True ti mostra i log SQL nel terminale

def init_db():
    # Questa funzione crea le tabelle nel database se non esistono
    SQLModel.metadata.create_all(engine)

def get_session():
    # Questa funzione ci dà una "sessione" per interagire con i dati
    with Session(engine) as session:
        yield session
