import pytest
from app.repositories import UserRepository, CategoryRepository
from app.schemas.category import CategoryCreate, CategoryUpdate
from app.models.user import User
from app.core.security import get_password_hash

# Mark all tests in this file as async
pytestmark = pytest.mark.asyncio


async def _create_test_user(db_session, username: str, email: str) -> User:
    """Helper function to create a user for test setup."""
    user_repo = UserRepository(db_session)
    hashed_password = get_password_hash("testpassword")
    user_model = User(username=username, email=email, hashed_password=hashed_password)
    return await user_repo.create(user_model)


async def test_category_crud_lifecycle(db_session):
    """
    Testa il ciclo CRUD completo asincrono per le categorie, associato a un utente.
    """
    print("\n--- Test: test_category_crud_lifecycle (async) ---")
    print("Scopo: Verificare il ciclo di vita completo di una categoria (CRUD).")

    # 1. SETUP: Crea un utente a cui associare le categorie
    user = await _create_test_user(db_session, "category_user_async", "cat_async@test.com")
    print(f"Setup: Utente creato (ID: {user.id}).")

    category_repo = CategoryRepository(db_session)

    # 2. CREATE
    print("\nAzione: Creazione di una nuova categoria...")
    category_data = CategoryCreate(name="Lavoro", color="blue")
    created_category_1 = await category_repo.create(obj_in=category_data, user_id=user.id)
    assert created_category_1.id is not None
    assert created_category_1.name == "Lavoro"
    assert created_category_1.user_id == user.id
    print(f"Risultato: Categoria 1 creata con successo (ID: {created_category_1.id}).")

    print("\nAzione: Creazione di una seconda categoria...")
    category_data_2 = CategoryCreate(name="Hobby", color="green")
    created_category_2 = await category_repo.create(obj_in=category_data_2, user_id=user.id)
    assert created_category_2.id is not None
    assert created_category_2.name == "Hobby"
    assert created_category_2.user_id == user.id
    print(f"Risultato: Categoria 2 creata con successo (ID: {created_category_2.id}).")

    # 3. READ (singola e tutte)
    print("\nAzione: Recupero della categoria 1 per ID...")
    fetched_category_1 = await category_repo.get_by_id(obj_id=created_category_1.id, user_id=user.id)
    assert fetched_category_1 is not None
    assert fetched_category_1.id == created_category_1.id
    print("Risultato: Categoria singola recuperata correttamente.")

    print("\nAzione: Recupero di tutte le categorie per l'utente...")
    all_categories = await category_repo.get_all_by_user(user_id=user.id)
    assert len(all_categories) == 2
    
    created_ids = {created_category_1.id, created_category_2.id}
    fetched_ids = {cat.id for cat in all_categories}
    assert created_ids == fetched_ids
    print("Risultato: Lista di categorie recuperata correttamente (contiene 2 elementi).")

    # 4. UPDATE
    print("\nAzione: Aggiornamento della categoria 1...")
    update_data = CategoryUpdate(name="Lavoro Urgente", color="red")
    updated_category = await category_repo.update(db_obj=fetched_category_1, obj_in=update_data)
    assert updated_category.name == "Lavoro Urgente"
    assert updated_category.color == "red"
    print("Risultato: Categoria 1 aggiornata con successo.")

    # 5. DELETE
    print("\nAzione: Eliminazione della categoria 1...")
    await category_repo.delete(db_obj=updated_category)
    
    deleted_category_1 = await category_repo.get_by_id(obj_id=created_category_1.id, user_id=user.id)
    assert deleted_category_1 is None
    print("Risultato: Categoria 1 eliminata con successo.")
    
    remaining_category = await category_repo.get_by_id(obj_id=created_category_2.id, user_id=user.id)
    assert remaining_category is not None
    await category_repo.delete(db_obj=remaining_category)
    deleted_category_2 = await category_repo.get_by_id(obj_id=created_category_2.id, user_id=user.id)
    assert deleted_category_2 is None
    print("Risultato: Categorie rimanenti eliminate per pulizia.")
    print("--- Test: test_category_crud_lifecycle (async) COMPLETATO ---")


async def test_get_category_for_wrong_user(db_session):
    """
    Verifica che un utente non possa vedere le categorie di un altro utente.
    """
    print("\n--- Test: test_get_category_for_wrong_user (async) ---")
    print("Scopo: Verificare l'isolamento dei dati tra utenti per le categorie.")

    # 1. SETUP: Crea due utenti e una categoria per il primo utente
    user1 = await _create_test_user(db_session, "user1_async", "u1_async@test.com")
    user2 = await _create_test_user(db_session, "user2_async", "u2_async@test.com")
    print(f"Setup: Creati utente 1 (ID: {user1.id}) e utente 2 (ID: {user2.id}).")

    category_repo = CategoryRepository(db_session)
    category_user1 = await category_repo.create(obj_in=CategoryCreate(name="Segreta"), user_id=user1.id)
    print(f"Setup: Creata categoria (ID: {category_user1.id}) per l'utente 1.")

    # 2. ACTION & ASSERT
    print(f"Azione: L'utente 2 tenta di recuperare la categoria dell'utente 1...")
    retrieved_category = await category_repo.get_by_id(obj_id=category_user1.id, user_id=user2.id)
    
    assert retrieved_category is None
    print("Risultato: La categoria non è stata trovata, come previsto.")
    print("--- Test: test_get_category_for_wrong_user (async) COMPLETATO ---")