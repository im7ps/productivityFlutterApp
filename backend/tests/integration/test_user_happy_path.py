import pytest
from httpx import AsyncClient
import uuid

# Mark all tests in this file as async and integration tests
pytestmark = [pytest.mark.asyncio, pytest.mark.integration]


async def test_full_user_lifecycle(test_client: AsyncClient):
    """
    Tests the complete user flow:
    1. Register a new user.
    2. Log in with the new credentials.
    3. Access a protected endpoint with the received token.
    """
    print("\n--- Test: test_full_user_lifecycle ---")
    print("Scope: Test user registration, login, and authenticated access.")

    # 1. Registration
    print("Action: Registering a new user...")
    user_email = f"testuser_{uuid.uuid4()}@example.com"
    user_password = "a_very_secure_password"
    registration_payload = {
        "username": "test_lifecycle_user",
        "email": user_email,
        "password": user_password,
    }
    
    response = await test_client.post("/api/v1/auth/register", json=registration_payload)
    
    assert response.status_code == 201, f"Registration failed: {response.text}"
    response_data = response.json()
    assert response_data["email"] == user_email
    assert response_data["username"] == "test_lifecycle_user"
    assert "id" in response_data
    print(f"Result: User '{user_email}' registered successfully.")

    # 2. Login
    print("\nAction: Logging in...")
    login_payload = {
        "username": "test_lifecycle_user",
        "password": user_password,
    }
    
    # Login uses form data, not JSON
    response = await test_client.post("/api/v1/auth/login", data=login_payload)
    
    assert response.status_code == 200, f"Login failed: {response.text}"
    token_data = response.json()
    assert "access_token" in token_data
    assert token_data["token_type"] == "bearer"
    access_token = token_data["access_token"]
    print("Result: Login successful, access token received.")

    # 3. Authenticated Endpoint Access
    print("\nAction: Accessing protected /users/me endpoint...")
    headers = {"Authorization": f"Bearer {access_token}"}
    response = await test_client.get("/api/v1/users/me", headers=headers)
    
    assert response.status_code == 200
    user_me_data = response.json()
    assert user_me_data["email"] == user_email
    assert user_me_data["username"] == "test_lifecycle_user"
    print("Result: Successfully accessed protected endpoint and got correct user data.")
    print("--- Test: test_full_user_lifecycle COMPLETE ---")