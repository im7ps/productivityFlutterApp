import pytest
from app.repositories import UserRepository
from app.schemas.user import UserCreate, UserUpdate

# --- HAPPY PATHS (Tutto va bene) ---

def test_crud_lifecycle(db_session):
    """
    Testa il ciclo completo: Create -> Read -> Update -> Delete
    """
    print("\n--- Test: test_crud_lifecycle ---")
    print("Scopo: Verificare il ciclo di vita completo di un'entità utente (CRUD).")
    
    repo = UserRepository(db_session)
    
    # 1. CREATE
    print("Azione: Creazione di un nuovo utente...")
    new_user_data = {"username": "lifecycle_user", "email": "life@test.com", "password": "pw"}
    print(f"Parametri: {new_user_data}")
    new_user = UserCreate(**new_user_data)
    created = repo.create_user(new_user)
    assert created.id is not None
    assert created.username == new_user_data["username"]
    print(f"Risultato: Utente creato con successo (ID: {created.id}).")

    # 2. UPDATE
    print("\nAzione: Aggiornamento dell'email dell'utente tramite repository...")
    update_data = UserUpdate(email="changed@test.com")
    print(f"Parametri: {update_data.model_dump(exclude_unset=True)}")
    updated = repo.update_user(user=created, user_update=update_data)
    assert updated.email == "changed@test.com"
    print("Risultato: Email aggiornata con successo.")

    # 3. READ (verifica che l'update sia persistito)
    fetched = repo.get_user_by_id(created.id)
    assert fetched.email == "changed@test.com"
    print("Risultato: Recuperato utente aggiornato, i dati corrispondono.")

    # 4. DELETE
    print("\nAzione: Eliminazione dell'utente tramite repository...")
    repo.delete_user(user=fetched)

    deleted_user = repo.get_user_by_id(created.id)
    assert deleted_user is None
    print("Risultato: Utente eliminato con successo. Il recupero ha restituito None, come atteso.")
    print("--- Test: test_crud_lifecycle COMPLETATO ---")


def test_create_and_get_user(db_session):
    """
    Test case for creating a user and retrieving it from the database.
    """
    print("\n--- Test: test_create_and_get_user ---")
    print("Scopo: Verificare la creazione e il recupero base di un utente.")
    # 1. Setup
    user_repo = UserRepository(db_session)
    user_data = {
        "username": "testuser",
        "email": "test@example.com",
        "password": "a_very_secure_password"
    }
    print(f"Parametri: {user_data}")
    user_to_create = UserCreate(**user_data)

    # 2. Action: Create the user
    print("Azione: Creazione utente...")
    created_user = user_repo.create_user(user_to_create)
    
    assert created_user is not None
    assert created_user.username == user_to_create.username
    assert created_user.email == user_to_create.email
    print("Risultato: Utente creato correttamente.")

    # 3. Action: Retrieve the user
    print(f"Azione: Recupero utente con username '{user_data['username']}'...")
    retrieved_user = user_repo.get_user_by_username(user_data['username'])

    # 4. Assert
    assert retrieved_user is not None
    assert retrieved_user.id == created_user.id
    assert retrieved_user.username == user_data['username']
    print("Risultato: Utente recuperato correttamente, i dati corrispondono.")
    print("--- Test: test_create_and_get_user COMPLETATO ---")
