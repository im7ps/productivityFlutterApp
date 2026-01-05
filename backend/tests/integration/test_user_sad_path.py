import pytest
from httpx import AsyncClient
import uuid

# Mark all tests in this file as async and integration tests
pytestmark = [pytest.mark.asyncio, pytest.mark.integration]


async def test_register_duplicate_username(test_client: AsyncClient):
    """
    Ensures the API prevents registration with a duplicate username.
    """
    print("\n--- Test: test_register_duplicate_username ---")
    print("Scope: Verify API rejects duplicate username on registration.")
    
    username = f"duplicate_user_{uuid.uuid4()}"
    
    # 1. Create the first user
    print(f"Action: Registering user '{username}' for the first time.")
    payload1 = {
        "username": username,
        "email": "email1@example.com",
        "password": "password123"
    }
    response1 = await test_client.post("/api/v1/auth/register", json=payload1)
    assert response1.status_code == 201
    print("Result: First user registered successfully.")

    # 2. Attempt to create the second user with the same username
    print(f"Action: Attempting to register user with the same username '{username}'.")
    payload2 = {
        "username": username,
        "email": "email2@example.com", # Different email
        "password": "password123"
    }
    response2 = await test_client.post("/api/v1/auth/register", json=payload2)

    # 3. Assert failure
    assert response2.status_code == 400
    assert "Username already registered" in response2.json()["detail"]
    print("Result: API correctly returned 400 with expected error message.")
    print("--- Test: test_register_duplicate_username COMPLETE ---")


async def test_register_duplicate_email(test_client: AsyncClient):
    """
    Ensures the API prevents registration with a duplicate email.
    """
    print("\n--- Test: test_register_duplicate_email ---")
    print("Scope: Verify API rejects duplicate email on registration.")

    email = f"duplicate_email_{uuid.uuid4()}@example.com"
    
    # 1. Create the first user
    print(f"Action: Registering user with email '{email}'.")
    payload1 = {
        "username": "user1",
        "email": email,
        "password": "password123"
    }
    response1 = await test_client.post("/api/v1/auth/register", json=payload1)
    assert response1.status_code == 201
    print("Result: First user registered successfully.")

    # 2. Attempt to create the second user with the same email
    print(f"Action: Attempting to register user with the same email '{email}'.")
    payload2 = {
        "username": "user2", # Different username
        "email": email,
        "password": "password123"
    }
    response2 = await test_client.post("/api/v1/auth/register", json=payload2)

    # 3. Assert failure
    assert response2.status_code == 400
    assert "Email already registered" in response2.json()["detail"]
    print("Result: API correctly returned 400 with expected error message.")
    print("--- Test: test_register_duplicate_email COMPLETE ---")


async def test_login_with_incorrect_password(test_client: AsyncClient):
    """
    Ensures the API prevents login with an incorrect password.
    """
    print("\n--- Test: test_login_with_incorrect_password ---")
    print("Scope: Verify API rejects login with wrong password.")

    # 1. Register a user
    username = f"user_for_login_test_{uuid.uuid4()}"
    print(f"Action: Registering user '{username}'.")
    registration_payload = {
        "username": username,
        "email": f"{username}@example.com",
        "password": "correct_password"
    }
    response = await test_client.post("/api/v1/auth/register", json=registration_payload)
    assert response.status_code == 201
    print("Result: User registered successfully.")

    # 2. Attempt to log in with the wrong password
    print("Action: Attempting to log in with an incorrect password.")
    login_payload = {
        "username": username,
        "password": "wrong_password"
    }
    response = await test_client.post("/api/v1/auth/login", data=login_payload)
    
    # 3. Assert failure
    assert response.status_code == 401
    assert "Incorrect username or password" in response.json()["detail"]
    print("Result: API correctly returned 401 with expected error message.")
    print("--- Test: test_login_with_incorrect_password COMPLETE ---")