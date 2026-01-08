import pytest
from sqlalchemy.exc import IntegrityError
from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession

from app.repositories.user_repo import UserRepository
from app.models.user import User
from app.core.security import get_password_hash

# Mark all tests in this file as async and needing a DB connection
pytestmark = [pytest.mark.asyncio, pytest.mark.db]


@pytest.fixture
def user_repo(db_session: AsyncSession) -> UserRepository:
    """Provides a UserRepository instance for the tests."""
    return UserRepository(session=db_session)


async def test_create_and_retrieve_user(user_repo: UserRepository):
    """
    Tests the basic functionality of creating a user and then retrieving them.
    """
    # Arrange
    user_model = User(
        username="testuser",
        email="test@example.com",
        hashed_password=get_password_hash("password")
    )
    
    # Action: Create user
    created_user = await user_repo.create(user_model)
    
    # Assert: Creation
    assert created_user.id is not None
    assert created_user.username == "testuser"
    assert created_user.email == "test@example.com"
    assert created_user.created_at is not None
    
    # Action: Retrieve user
    retrieved_user = await user_repo.get_by_username("testuser")
    
    # Assert: Retrieval
    assert retrieved_user is not None
    assert retrieved_user.id == created_user.id
    assert retrieved_user.username == "testuser"


async def test_get_by_email_is_case_insensitive(user_repo: UserRepository):
    """
    Tests that retrieving a user by email is case-insensitive.
    The repository MUST handle this (e.g., using ilike in PostgreSQL).
    """
    # Arrange
    email = "Case.Test@Example.Com"
    user_model = User(
        username="caseuser",
        email=email.lower(),
        hashed_password=get_password_hash("password")
    )
    await user_repo.create(user_model)
    
    # Action: Retrieve with a different case (UPPERCASE)
    retrieved_user = await user_repo.get_by_email(email.upper())

    # Assert
    assert retrieved_user is not None, f"Repository should find user by email {email.upper()} regardless of case"
    assert retrieved_user.username == "caseuser"
    assert retrieved_user.email == email.lower()


async def test_create_user_raises_integrity_error_for_duplicate_username(user_repo: UserRepository):
    """
    Tests that the database's UNIQUE constraint for 'username' is enforced,
    raising an IntegrityError for duplicates.
    """
    # Arrange: Create the first user
    user1 = User(
        username="duplicate_user",
        email="email1@example.com",
        hashed_password=get_password_hash("password")
    )
    await user_repo.create(user1)

    # Arrange: Create a second user with the same username
    user2 = User(
        username="duplicate_user", # Same username
        email="email2@example.com",
        hashed_password=get_password_hash("password")
    )
    
    # Action & Assert
    with pytest.raises(IntegrityError):
        await user_repo.create(user2)


async def test_create_user_raises_integrity_error_for_duplicate_email(user_repo: UserRepository):
    """
    Tests that the database's UNIQUE constraint for 'email' is enforced,
    raising an IntegrityError for duplicates.
    """
    # Arrange: Create the first user
    user1 = User(
        username="user1",
        email="duplicate.email@example.com",
        hashed_password=get_password_hash("password")
    )
    await user_repo.create(user1)

    # Arrange: Create a second user with the same email
    user2 = User(
        username="user2",
        email="duplicate.email@example.com", # Same email
        hashed_password=get_password_hash("password")
    )
    
    # Action & Assert
    with pytest.raises(IntegrityError):
        await user_repo.create(user2)
