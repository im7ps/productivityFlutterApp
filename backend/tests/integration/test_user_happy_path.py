import pytest
from app.repositories import UserRepository
from app.schemas.user import UserCreate, UserUpdate

# Mark all tests in this file as async
pytestmark = pytest.mark.asyncio

# --- HAPPY PATHS (Tutto va bene) ---

async def test_crud_lifecycle(db_session):
    """
    Testa il ciclo completo asincrono: Create -> Read -> Update -> Delete
    """
    print("\n--- Test: test_crud_lifecycle (async) ---")
    print("Scopo: Verificare il ciclo di vita completo di un\'entità utente (CRUD).")
    
    repo = UserRepository(db_session)
    
    # 1. CREATE
    print("Azione: Creazione di un nuovo utente...")
    new_user_data = {"username": "lifecycle_user_async", "email": "life_async@test.com", "password": "pw"}
    print(f"Parametri: {new_user_data}")
    new_user = UserCreate(**new_user_data)
    created = await repo.create_user(new_user)
    assert created.id is not None
    assert created.username == new_user_data["username"]
    print(f"Risultato: Utente creato con successo (ID: {created.id}).")

    # 2. UPDATE
    print("\nAzione: Aggiornamento dell\'email dell\'utente tramite repository...")
    update_data = UserUpdate(email="changed_async@test.com")
    print(f"Parametri: {update_data.model_dump(exclude_unset=True)}")
    updated = await repo.update_user(user=created, user_update=update_data)
    assert updated.email == "changed_async@test.com"
    print("Risultato: Email aggiornata con successo.")

    # 3. READ (verifica che l\'update sia persistito)
    fetched = await repo.get_user_by_id(created.id)
    assert fetched.email == "changed_async@test.com"
    print("Risultato: Recuperato utente aggiornato, i dati corrispondono.")

    # 4. DELETE
    print("\nAzione: Eliminazione dell\'utente tramite repository...")
    await repo.delete_user(user=fetched)

    deleted_user = await repo.get_user_by_id(created.id)
    assert deleted_user is None
    print("Risultato: Utente eliminato con successo. Il recupero ha restituito None, come atteso.")
    print("--- Test: test_crud_lifecycle (async) COMPLETATO ---")


async def test_create_and_get_user(db_session):
    """
    Testa la creazione e il recupero asincrono di un utente.
    """
    print("\n--- Test: test_create_and_get_user (async) ---")
    print("Scopo: Verificare la creazione e il recupero base di un utente.")
    # 1. Setup
    user_repo = UserRepository(db_session)
    user_data = {
        "username": "testuser_async",
        "email": "test_async@example.com",
        "password": "a_very_secure_password"
    }
    print(f"Parametri: {user_data}")
    user_to_create = UserCreate(**user_data)

    # 2. Action: Create the user
    print("Azione: Creazione utente...")
    created_user = await user_repo.create_user(user_to_create)
    
    assert created_user is not None
    assert created_user.username == user_to_create.username
    assert created_user.email == user_to_create.email
    print("Risultato: Utente creato correttamente.")

    # 3. Action: Retrieve the user
    print(f"Azione: Recupero utente con username '{user_data['username']}'...")
    retrieved_user = await user_repo.get_user_by_username(user_data['username'])

    # 4. Assert
    assert retrieved_user is not None
    assert retrieved_user.id == created_user.id
    assert retrieved_user.username == user_data['username']
    print("Risultato: Utente recuperato correttamente, i dati corrispondono.")
    print("--- Test: test_create_and_get_user (async) COMPLETATO ---")