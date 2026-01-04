import pytest
from sqlalchemy.exc import IntegrityError
from app.repositories.user_repo import UserRepository
from app.schemas.user import UserCreate

# Mark all tests in this file as async
pytestmark = pytest.mark.asyncio

# --- SAD PATHS (Gestione Errori) ---

async def test_prevent_duplicate_username(db_session):
    """
    Deve fallire se proviamo a inserire due utenti con lo stesso username (async).
    """
    print("\n--- Test: test_prevent_duplicate_username (async) ---")
    print("Scopo: Verificare che il DB impedisca la creazione di utenti con username duplicato.")
    repo = UserRepository(db_session)
    
    user_data = {"username": "unique_guy_async", "password": "pw"}
    print(f"Azione: Creazione del primo utente con username '{user_data['username']}'.")
    user1 = UserCreate(email="u1_async@test.com", **user_data)
    await repo.create_user(user1)
    
    print(f"Azione: Tentativo di creazione del secondo utente con lo stesso username.")
    user2 = UserCreate(email="u2_async@test.com", **user_data)

    print("Risultato Atteso: Sollevamento di un'eccezione 'IntegrityError'.")
    with pytest.raises(IntegrityError) as excinfo:
        await repo.create_user(user2)
    
    print(f"Risultato: Eccezione '{excinfo.type.__name__}' catturata correttamente.")
    print("--- Test: test_prevent_duplicate_username (async) COMPLETATO ---")


async def test_prevent_duplicate_email(db_session):
    """
    Verifica vincolo unique sulla email (async).
    """
    print("\n--- Test: test_prevent_duplicate_email (async) ---")
    print("Scopo: Verificare che il DB impedisca la creazione di utenti con email duplicata.")
    repo = UserRepository(db_session)

    email_data = {"email": "shared_async@test.com", "password": "pw"}
    print(f"Azione: Creazione del primo utente con email '{email_data['email']}'.")
    user1 = UserCreate(username="user_a_async", **email_data)
    await repo.create_user(user1)

    print(f"Azione: Tentativo di creazione del secondo utente con la stessa email.")
    user2 = UserCreate(username="user_b_async", **email_data)

    print("Risultato Atteso: Sollevamento di un'eccezione 'IntegrityError'.")
    with pytest.raises(IntegrityError):
        await repo.create_user(user2)
    
    print(f"Risultato: Eccezione 'IntegrityError' catturata correttamente.")
    print("--- Test: test_prevent_duplicate_email (async) COMPLETATO ---")


async def test_create_user_minimal_data(db_session):
    """
    Verifica la creazione di utenti con dati minimi (async).
    """
    print("\n--- Test: test_create_user_minimal_data (async) ---")
    print("Scopo: Verificare la creazione di un utente con i dati minimi indispensabili.")
    repo = UserRepository(db_session)
    
    user_data = UserCreate(
        username="minimal_user_async", 
        email="minimal_async@test.com", 
        password="a_password"
    )
    print(f"Azione: Creazione utente con dati minimi: {user_data.model_dump(exclude={'password'})}")

    created_user = await repo.create_user(user_data)
    
    print("Risultato Atteso: Un oggetto utente valido e persistito nel DB.")
    assert created_user is not None
    assert created_user.id is not None
    assert created_user.username == user_data.username
    
    print("Risultato: Utente creato con successo con i dati minimi.")
    print("--- Test: test_create_user_minimal_data (async) COMPLETATO ---")

async def test_get_non_existent_user(db_session):
    """
    Verifica che la ricerca di un utente inesistente restituisca None (async).
    """
    print("\n--- Test: test_get_non_existent_user (async) ---")
    print("Scopo: Verificare che la ricerca di un utente inesistente restituisca None.")
    user_repo = UserRepository(db_session)
    username = "nonexistent_async"
    print(f"Azione: Tentativo di recupero utente con username '{username}'.")

    retrieved_user = await user_repo.get_user_by_username(username)

    print("Risultato Atteso: Il risultato della ricerca deve essere None.")
    assert retrieved_user is None
    print("Risultato: La ricerca ha restituito None, come atteso.")
    print("--- Test: test_get_non_existent_user (async) COMPLETATO ---")