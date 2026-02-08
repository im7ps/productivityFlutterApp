import pytest
from httpx import AsyncClient
from app.core.security import verify_password
from app.models.user import User
from app.repositories.user_repo import UserRepo

# --- Local Fixtures for this test module ---

@pytest.fixture
async def setup_user(auth_user_context):
    """
    Uses the factory fixture from conftest to create a user and get headers.
    Returns a dict with user info and headers.
    """
    return await auth_user_context(username_suffix="_update_test")

@pytest.fixture
async def test_user_token_headers(setup_user):
    return setup_user["headers"]

@pytest.fixture
async def test_user(setup_user, db_session):
    """
    Retrieves the actual User DB object created by the setup_user fixture.
    """
    repo = UserRepo(db_session)
    # The setup_user factory returns user_id as a UUID string, assume repo needs UUID or str? 
    # Let's check repo.get implementation. It takes 'id'.
    # setup_user['user_id'] is usually a string UUID from JSON response.
    return await repo.get(setup_user["user_id"])

# --- Tests ---

@pytest.mark.asyncio
async def test_update_user_me_profile(
    test_client: AsyncClient, # Use the correct fixture name from conftest
    test_user: User,
    test_user_token_headers: dict[str, str]
):
    """
    Test PATCH /users/me to update profile info.
    """
    payload = {
        "username": "updatedusername"
    }
    
    response = await test_client.patch(
        "/api/v1/users/me",
        json=payload,
        headers=test_user_token_headers
    )
    
    assert response.status_code == 200, f"Response: {response.text}"
    data = response.json()
    assert data["username"] == "updatedusername"


@pytest.mark.asyncio
async def test_update_user_me_password(
    test_client: AsyncClient, # Use the correct fixture name
    test_user: User,
    test_user_token_headers: dict[str, str],
    db_session
):
    """
    Test PATCH /users/me to update password.
    Verifies that the password is hashed correctly in the DB.
    """
    new_password = "New_secure_password_123_!"
    payload = {
        "password": new_password
    }
    
    response = await test_client.patch(
        "/api/v1/users/me",
        json=payload,
        headers=test_user_token_headers
    )
    
    assert response.status_code == 200, f"Response: {response.text}"
    
    # Verify we can login with the new password
    # Or check directly in DB (faster/more direct for this test)
    await db_session.refresh(test_user)
    assert verify_password(new_password, test_user.hashed_password)
