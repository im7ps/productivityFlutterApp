import pytest
from app.repositories import UserRepository, CategoryRepository
from app.schemas.user import UserCreate
from app.schemas.category import CategoryCreate, CategoryUpdate

def test_category_crud_lifecycle(db_session):
    """
    Testa il ciclo CRUD completo per le categorie, associato a un utente.
    """
    print("\n--- Test: test_category_crud_lifecycle ---")
    print("Scopo: Verificare il ciclo di vita completo di una categoria (CRUD).")

    # 1. SETUP: Crea un utente a cui associare le categorie
    user_repo = UserRepository(db_session)
    user_data = UserCreate(username="category_user", email="cat@test.com", password="pw")
    user = user_repo.create_user(user_data)
    print(f"Setup: Utente creato (ID: {user.id}).")

    category_repo = CategoryRepository(db_session)

    # 2. CREATE
    print("\nAzione: Creazione di una nuova categoria...")
    category_data = CategoryCreate(name="Lavoro", color="blue")
    print(f"Parametri: {category_data.model_dump()}")
    created_category_1 = category_repo.create(obj_in=category_data, user_id=user.id)
    assert created_category_1.id is not None
    assert created_category_1.name == "Lavoro"
    assert created_category_1.user_id == user.id
    print(f"Risultato: Categoria 1 creata con successo (ID: {created_category_1.id}).")

    print("\nAzione: Creazione di una seconda categoria...")
    category_data_2 = CategoryCreate(name="Hobby", color="green")
    print(f"Parametri: {category_data_2.model_dump()}")
    created_category_2 = category_repo.create(obj_in=category_data_2, user_id=user.id)
    assert created_category_2.id is not None
    assert created_category_2.name == "Hobby"
    assert created_category_2.user_id == user.id
    print(f"Risultato: Categoria 2 creata con successo (ID: {created_category_2.id}).")

    # 3. READ (singola e tutte)
    print("\nAzione: Recupero della categoria 1 per ID...")
    fetched_category_1 = category_repo.get_by_id(obj_id=created_category_1.id, user_id=user.id)
    assert fetched_category_1 is not None
    assert fetched_category_1.id == created_category_1.id
    print("Risultato: Categoria singola recuperata correttamente.")

    print("\nAzione: Recupero di tutte le categorie per l'utente...")
    all_categories = category_repo.get_all_by_user(user_id=user.id)
    assert len(all_categories) == 2
    
    created_ids = {created_category_1.id, created_category_2.id}
    fetched_ids = {cat.id for cat in all_categories}
    assert created_ids == fetched_ids
    print("Risultato: Lista di categorie recuperata correttamente (contiene 2 elementi).")

    # 4. UPDATE
    print("\nAzione: Aggiornamento della categoria 1...")
    update_data = CategoryUpdate(name="Lavoro Urgente", color="red")
    print(f"Parametri: {update_data.model_dump(exclude_unset=True)}")
    updated_category = category_repo.update(db_obj=fetched_category_1, obj_in=update_data)
    assert updated_category.name == "Lavoro Urgente"
    assert updated_category.color == "red"
    print("Risultato: Categoria 1 aggiornata con successo.")

    # 5. DELETE
    print("\nAzione: Eliminazione della categoria 1...")
    category_repo.delete(db_obj=updated_category)
    
    deleted_category_1 = category_repo.get_by_id(obj_id=created_category_1.id, user_id=user.id)
    assert deleted_category_1 is None
    print("Risultato: Categoria 1 eliminata con successo.")
    
    # Verifica che la Categoria 2 esista ancora
    remaining_category = category_repo.get_by_id(obj_id=created_category_2.id, user_id=user.id)
    assert remaining_category is not None
    assert remaining_category.name == "Hobby"
    print("Risultato: Categoria 2 esiste ancora.")

    # Elimina anche la Categoria 2 per pulizia
    print("\nAzione: Eliminazione della categoria 2 per pulizia...")
    category_repo.delete(db_obj=remaining_category)
    deleted_category_2 = category_repo.get_by_id(obj_id=created_category_2.id, user_id=user.id)
    assert deleted_category_2 is None
    print("Risultato: Categoria 2 eliminata con successo.")
    print("--- Test: test_category_crud_lifecycle COMPLETATO ---")

def test_get_category_for_wrong_user(db_session):
    """
    Verifica che un utente non possa vedere le categorie di un altro utente.
    """
    print("\n--- Test: test_get_category_for_wrong_user ---")
    print("Scopo: Verificare l'isolamento dei dati tra utenti per le categorie.")

    # 1. SETUP: Crea due utenti e una categoria per il primo utente
    user_repo = UserRepository(db_session)
    user1 = user_repo.create_user(UserCreate(username="user1", email="u1@test.com", password="pw"))
    user2 = user_repo.create_user(UserCreate(username="user2", email="u2@test.com", password="pw"))
    print(f"Setup: Creati utente 1 (ID: {user1.id}) e utente 2 (ID: {user2.id}).")

    category_repo = CategoryRepository(db_session)
    category_user1 = category_repo.create(obj_in=CategoryCreate(name="Segreta"), user_id=user1.id)
    print(f"Setup: Creata categoria (ID: {category_user1.id}) per l'utente 1.")

    # 2. ACTION & ASSERT
    print(f"Azione: L'utente 2 tenta di recuperare la categoria dell'utente 1...")
    retrieved_category = category_repo.get_by_id(obj_id=category_user1.id, user_id=user2.id)
    
    print("Risultato Atteso: Il risultato deve essere None.")
    assert retrieved_category is None
    print("Risultato: La categoria non è stata trovata, come previsto.")
    print("--- Test: test_get_category_for_wrong_user COMPLETATO ---")
