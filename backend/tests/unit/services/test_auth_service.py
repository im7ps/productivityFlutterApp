import pytest
from app.core.exceptions import InvalidCredentials
from unittest.mock import AsyncMock

from app.services.auth_service import AuthService
from app.services.user_service import UserService
from app.schemas.user import UserCreate, UserPublic
from app.models.user import User
from app.core.security import get_password_hash
import uuid
from datetime import datetime

from tests.unit.fakes import FakeUserRepo

# --- Test Fixtures ---

@pytest.fixture
def fake_user_repo() -> FakeUserRepo:
    """Provides a fresh FakeUserRepo for each test."""
    return FakeUserRepo()

@pytest.fixture
def user_service(fake_user_repo: FakeUserRepo) -> UserService:
    """Provides a UserService instance with a fake repository and mock session."""
    return UserService(session=AsyncMock(), user_repo=fake_user_repo)

@pytest.fixture
def auth_service(user_service: UserService) -> AuthService:
    """Provides an AuthService instance with a real UserService using a fake repo."""
    return AuthService(user_service=user_service)

# --- AuthService Unit Tests ---

@pytest.mark.asyncio
async def test_authenticate_user_success(auth_service: AuthService, fake_user_repo: FakeUserRepo):
    """
    Tests the happy path for authenticating a user with correct credentials.
    """
    # Arrange: Create a user directly in the fake repo
    password = "CorrectPassword123!"
    user = User(
        id=uuid.uuid4(),
        username="testuser",
        email="test@example.com",
        hashed_password=get_password_hash(password),
        created_at=datetime.utcnow()
    )
    await fake_user_repo.create(user)
    
    # Action
    authenticated_user = await auth_service.authenticate_user(
        username="testuser",
        password=password
    )
    
    # Assert
    assert authenticated_user is not None
    assert authenticated_user.username == "testuser"
    assert authenticated_user.id == user.id

@pytest.mark.asyncio
async def test_authenticate_user_not_found(auth_service: AuthService):
    """
    Tests that authentication fails with InvalidCredentials if the user does not exist.
    """
    # Action & Assert
    with pytest.raises(InvalidCredentials) as exc_info:
        await auth_service.authenticate_user(
            username="nonexistent",
            password="any_password"
        )
    assert "Incorrect username or password" in exc_info.value.message

@pytest.mark.asyncio
async def test_authenticate_user_wrong_password(auth_service: AuthService, fake_user_repo: FakeUserRepo):
    """
    Tests that authentication fails with InvalidCredentials if the password is incorrect.
    """
    # Arrange: Create a user
    password = "CorrectPassword123!"
    user = User(
        username="testuser",
        hashed_password=get_password_hash(password)
    )
    await fake_user_repo.create(user)
    
    # Action & Assert
    with pytest.raises(InvalidCredentials) as exc_info:
        await auth_service.authenticate_user(
            username="testuser",
            password="WrongPassword!"
        )
    assert "Incorrect username or password" in exc_info.value.message


def test_create_jwt(auth_service: AuthService):
    """
    Tests the creation of a JWT token dictionary.
    """
    # Arrange
    user_public = UserPublic(
        id=uuid.uuid4(),
        username="testuser",
        email="test@example.com",
        created_at=datetime.utcnow()
    )
    
    # Action
    token_data = auth_service.create_jwt(user_public)
    
    # Assert
    assert "access_token" in token_data
    assert "token_type" in token_data
    assert token_data["token_type"] == "bearer"
    assert isinstance(token_data["access_token"], str)
