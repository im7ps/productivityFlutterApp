import pytest
from sqlalchemy.exc import IntegrityError
from app.repositories.user_repo import UserRepository
from app.schemas.user import UserCreate

# --- SAD PATHS (Gestione Errori) ---

def test_prevent_duplicate_username(db_session):
    """
    Deve fallire se proviamo a inserire due utenti con lo stesso username.
    Questo verifica che i vincoli UNIQUE del DB funzionino.
    """
    print("\n--- Test: test_prevent_duplicate_username ---")
    print("Scopo: Verificare che il DB impedisca la creazione di utenti con username duplicato.")
    repo = UserRepository(db_session)
    
    user_data = {"username": "unique_guy", "password": "pw"}
    print(f"Azione: Creazione del primo utente con username '{user_data['username']}'.")
    user1 = UserCreate(email="u1@test.com", **user_data)
    repo.create_user(user1)
    
    print(f"Azione: Tentativo di creazione del secondo utente con lo stesso username.")
    user2 = UserCreate(email="u2@test.com", **user_data)

    print("Risultato Atteso: Sollevamento di un'eccezione 'IntegrityError'.")
    with pytest.raises(IntegrityError) as excinfo:
        repo.create_user(user2)
        db_session.flush() # Necessario per scatenare l'errore del DB
    
    print(f"Risultato: Eccezione '{excinfo.type.__name__}' catturata correttamente.")
    print("--- Test: test_prevent_duplicate_username COMPLETATO ---")


def test_prevent_duplicate_email(db_session):
    """
    Verifica vincolo unique sulla email
    """
    print("\n--- Test: test_prevent_duplicate_email ---")
    print("Scopo: Verificare che il DB impedisca la creazione di utenti con email duplicata.")
    repo = UserRepository(db_session)

    email_data = {"email": "shared@test.com", "password": "pw"}
    print(f"Azione: Creazione del primo utente con email '{email_data['email']}'.")
    user1 = UserCreate(username="user_a", **email_data)
    repo.create_user(user1)

    print(f"Azione: Tentativo di creazione del secondo utente con la stessa email.")
    user2 = UserCreate(username="user_b", **email_data)

    print("Risultato Atteso: Sollevamento di un'eccezione 'IntegrityError'.")
    with pytest.raises(IntegrityError) as excinfo:
        repo.create_user(user2)
        db_session.flush()
    
    print(f"Risultato: Eccezione '{excinfo.type.__name__}' catturata correttamente.")
    print("--- Test: test_prevent_duplicate_email COMPLETATO ---")


def test_create_user_minimal_data(db_session):
    """
    Verifica che possiamo creare utenti con i dati minimi richiesti (username, email, password).
    Questo test assicura che non ci siano vincoli nascosti o valori di default problematici.
    """
    print("\n--- Test: test_create_user_minimal_data ---")
    print("Scopo: Verificare la creazione di un utente con i dati minimi indispensabili.")
    repo = UserRepository(db_session)
    
    # Dati minimi richiesti dallo schema UserCreate
    user_data = UserCreate(
        username="minimal_user", 
        email="minimal@test.com", 
        password="a_password" # La password non può essere vuota per la logica di hashing
    )
    print(f"Azione: Creazione utente con dati minimi: {user_data.model_dump(exclude={'password'})}")

    created_user = repo.create_user(user_data)
    
    # VERIFICA
    print("Risultato Atteso: Un oggetto utente valido e persistito nel DB.")
    assert created_user is not None
    assert created_user.id is not None
    assert created_user.username == user_data.username
    assert created_user.email == user_data.email
    assert created_user.hashed_password is not None
    assert created_user.hashed_password != user_data.password # Verifica che la password sia stata hashata
    
    print("Risultato: Utente creato con successo con i dati minimi.")
    print("--- Test: test_create_user_minimal_data COMPLETATO ---")

def test_get_non_existent_user(db_session):
    """
    Test case to ensure that querying for a non-existent user returns None.
    """
    print("\n--- Test: test_get_non_existent_user ---")
    print("Scopo: Verificare che la ricerca di un utente inesistente restituisca None.")
    user_repo = UserRepository(db_session)
    username = "nonexistent"
    print(f"Azione: Tentativo di recupero utente con username '{username}'.")

    retrieved_user = user_repo.get_user_by_username(username)

    print("Risultato Atteso: Il risultato della ricerca deve essere None.")
    assert retrieved_user is None
    print("Risultato: La ricerca ha restituito None, come atteso.")
    print("--- Test: test_get_non_existent_user COMPLETATO ---")
