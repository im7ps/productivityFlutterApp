import pytest
from app.repositories import UserRepo, DimensionRepo
from app.schemas.category import CategoryCreate, CategoryUpdate
from app.models.user import User
from app.core.security import get_password_hash

# Mark all tests in this file as async
pytestmark = pytest.mark.asyncio

@pytest.fixture
async def test_user(db_session) -> User:
    """Fixture to provide a clean user for each test."""
    user_repo = UserRepo(db_session)
    hashed_password = get_password_hash("testpassword")
    user_model = User(
        username="category_test_user", 
        email="cat_test@test.com", 
        hashed_password=hashed_password
    )
    return await user_repo.create(user_model)

async def test_create_category(db_session, test_user: User):
    category_repo = DimensionRepo(db_session)
    category_data = CategoryCreate(name="Work", color="blue")
    
    created_category = await category_repo.create(obj_in=category_data, user_id=test_user.id)
    
    assert created_category.id is not None
    assert created_category.name == "Work"
    assert created_category.user_id == test_user.id

async def test_get_all_categories_by_user(db_session, test_user: User):
    category_repo = DimensionRepo(db_session)
    await category_repo.create(obj_in=CategoryCreate(name="Cat 1"), user_id=test_user.id)
    await category_repo.create(obj_in=CategoryCreate(name="Cat 2"), user_id=test_user.id)

    all_categories = await category_repo.get_all_by_user(user_id=test_user.id)
    
    assert len(all_categories) == 2
    assert {c.name for c in all_categories} == {"Cat 1", "Cat 2"}

async def test_update_category(db_session, test_user: User):
    category_repo = DimensionRepo(db_session)
    category = await category_repo.create(obj_in=CategoryCreate(name="Old Name"), user_id=test_user.id)
    
    update_data = CategoryUpdate(name="New Name", color="red")
    updated_category = await category_repo.update(db_obj=category, obj_in=update_data)
    
    assert updated_category.name == "New Name"
    assert updated_category.color == "red"

async def test_delete_category(db_session, test_user: User):
    category_repo = DimensionRepo(db_session)
    category = await category_repo.create(obj_in=CategoryCreate(name="To Delete"), user_id=test_user.id)
    
    await category_repo.delete(db_obj=category)
    
    fetched = await category_repo.get_by_id(obj_id=category.id, user_id=test_user.id)
    assert fetched is None

async def test_get_category_for_wrong_user(db_session):
    user_repo = UserRepo(db_session)
    user1 = await user_repo.create(User(
        username="u1", email="u1@test.com", hashed_password=get_password_hash("p")
    ))
    user2 = await user_repo.create(User(
        username="u2", email="u2@test.com", hashed_password=get_password_hash("p")
    ))

    category_repo = DimensionRepo(db_session)
    cat_u1 = await category_repo.create(obj_in=CategoryCreate(name="Private"), user_id=user1.id)

    retrieved = await category_repo.get_by_id(obj_id=cat_u1.id, user_id=user2.id)
    assert retrieved is None
