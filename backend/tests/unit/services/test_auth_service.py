import pytest
from fastapi import HTTPException
from unittest.mock import MagicMock

from app.services.auth_service import AuthService
from app.services.user_service import UserService
from app.schemas.user import UserCreate, UserPublic
from app.models.user import User
from app.core.security import get_password_hash
import uuid
from datetime import datetime

# --- Re-using the Fake Repo from user service tests ---

class FakeUserRepository:
    """
    A fake, in-memory repository that mimics the interface of UserRepository
    for unit testing services in isolation.
    """
    def __init__(self):
        self.users: list[User] = []

    async def create(self, user_model: User) -> User:
        user_model.id = user_model.id or uuid.uuid4()
        user_model.created_at = user_model.created_at or datetime.utcnow()
        self.users.append(user_model)
        return user_model

    async def get_by_username(self, username: str) -> User | None:
        return next((u for u in self.users if u.username == username), None)
    
    async def get_by_email(self, email: str) -> User | None:
        return next((u for u in self.users if u.email == email), None)

# --- Test Fixtures ---

@pytest.fixture
def fake_user_repo() -> FakeUserRepository:
    """Provides a fresh FakeUserRepository for each test."""
    return FakeUserRepository()

@pytest.fixture
def user_service(fake_user_repo: FakeUserRepository) -> UserService:
    """Provides a UserService instance with a fake repository."""
    return UserService(user_repo=fake_user_repo)

@pytest.fixture
def auth_service(user_service: UserService) -> AuthService:
    """Provides an AuthService instance with a real UserService using a fake repo."""
    return AuthService(user_service=user_service)

# --- AuthService Unit Tests ---

@pytest.mark.asyncio
async def test_authenticate_user_success(auth_service: AuthService, fake_user_repo: FakeUserRepository):
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
    Tests that authentication fails if the user does not exist.
    """
    # Action & Assert
    with pytest.raises(HTTPException) as exc_info:
        await auth_service.authenticate_user(
            username="nonexistent",
            password="any_password"
        )
    assert exc_info.value.status_code == 401
    assert "Incorrect username or password" in exc_info.value.detail

@pytest.mark.asyncio
async def test_authenticate_user_wrong_password(auth_service: AuthService, fake_user_repo: FakeUserRepository):
    """
    Tests that authentication fails if the password is incorrect.
    """
    # Arrange: Create a user
    password = "CorrectPassword123!"
    user = User(
        username="testuser",
        hashed_password=get_password_hash(password)
    )
    await fake_user_repo.create(user)
    
    # Action & Assert
    with pytest.raises(HTTPException) as exc_info:
        await auth_service.authenticate_user(
            username="testuser",
            password="WrongPassword!"
        )
    assert exc_info.value.status_code == 401
    assert "Incorrect username or password" in exc_info.value.detail


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
