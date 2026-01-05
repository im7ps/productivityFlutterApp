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


async def test_get_by_email_is_case_insensitive(user_repo: UserRepository, db_session: AsyncSession):
    """
    Tests that retrieving a user by email is case-insensitive.
    Note: This behavior often depends on the database's collation.
    PostgreSQL's default collation is case-sensitive, so we must query using `ilike` or `lower`.
    Let's check if the current implementation supports it. If not, this test will fail
    and highlight a need for improvement in the repository.
    """
    # Arrange
    user_model = User(
        username="caseuser",
        email="case.test@example.com", # stored in lowercase
        hashed_password=get_password_hash("password")
    )
    await user_repo.create(user_model)
    
    # Action: Retrieve with a different case
    # The original repo uses `==`, which is case-sensitive in PostgreSQL.
    # We will perform a manual query to demonstrate the correct way and check the repo method.
    
    # 1. Test the repository's current behavior
    retrieved_user_case_sensitive = await user_repo.get_by_email("CASE.TEST@example.com")
    
    # 2. Perform a correct case-insensitive query for comparison
    stmt = select(User).where(User.email.ilike("CASE.TEST@example.com"))
    result = await db_session.execute(stmt)
    retrieved_user_case_insensitive = result.scalars().first()

    # Assert
    assert retrieved_user_case_insensitive is not None, "Case-insensitive query should find the user"
    # This assertion checks our repository logic. If it fails, the repo needs a fix.
    assert retrieved_user_case_sensitive is not None, "Repository's get_by_email should be case-insensitive"
    assert retrieved_user_case_sensitive.username == "caseuser"


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
