import pytest
from httpx import AsyncClient
import uuid

# Mark all tests in this file as async and needing a DB connection
pytestmark = [pytest.mark.asyncio, pytest.mark.db]


# --- Test Fixtures ---

@pytest.fixture(scope="module")
def user_credentials() -> dict:
    """Provides a consistent set of user credentials for the tests."""
    # Use a shorter, valid, alphanumeric username
    username = f"authuser{uuid.uuid4().hex[:8]}"
    return {
        "username": username,
        "email": f"{username}@example.com",
        "password": "ValidPassword123!",
    }


# --- Registration and Login Flow Tests ---

@pytest.mark.parametrize("payload_update, expected_error_field", [
    ({"password": "short"}, "password"),
    ({"email": "not-an-email"}, "email"),
    ({"username": "a"}, "username"),
])
async def test_register_invalid_payload(
    test_client: AsyncClient, payload_update: dict, expected_error_field: str
):
    """
    Tests that user registration fails with a 422 Unprocessable Entity
    error when the payload is invalid (e.g., short password, bad email).
    """
    # Arrange
    invalid_payload = {
        "username": "validation_test",
        "email": "validation@test.com",
        "password": "ValidPassword123!",
        **payload_update, # Overwrite with the invalid value
    }

    # Action
    response = await test_client.post("/api/v1/auth/register", json=invalid_payload)

    # Assert
    assert response.status_code == 422
    error_data = response.json()
    assert "detail" in error_data
    # Check that the error message points to the correct field
    assert any(err["loc"][1] == expected_error_field for err in error_data["detail"])


async def test_full_auth_lifecycle(test_client: AsyncClient, user_credentials: dict):
    """
    Tests the complete user flow: register, log in, and access a protected endpoint.
    """
    # 1. Register User
    response = await test_client.post("/api/v1/auth/register", json=user_credentials)
    assert response.status_code == 201, f"Registration failed: {response.text}"
    assert response.json()["email"] == user_credentials["email"]

    # 2. Login
    login_payload = {
        "username": user_credentials["username"],
        "password": user_credentials["password"],
    }
    response = await test_client.post("/api/v1/auth/login", data=login_payload)
    assert response.status_code == 200, f"Login failed: {response.text}"
    token_data = response.json()
    assert "access_token" in token_data
    access_token = token_data["access_token"]

    # 3. Access Protected Endpoint
    headers = {"Authorization": f"Bearer {access_token}"}
    response = await test_client.get("/api/v1/users/me", headers=headers)
    assert response.status_code == 200
    assert response.json()["email"] == user_credentials["email"]


async def test_register_duplicate_username(test_client: AsyncClient, user_credentials: dict):
    """Ensures the API prevents registration with a duplicate username."""
    # 1. Create the first user
    response1 = await test_client.post("/api/v1/auth/register", json=user_credentials)
    assert response1.status_code == 201

    # 2. Attempt to create a second user with the same username
    payload2 = user_credentials.copy()
    payload2["email"] = "different@email.com" # Use a different email
    response2 = await test_client.post("/api/v1/auth/register", json=payload2)

    # 3. Assert failure
    assert response2.status_code == 409
    assert "Username already registered" in response2.json()["detail"]


async def test_register_duplicate_email(test_client: AsyncClient, user_credentials: dict):
    """Ensures the API prevents registration with a duplicate email."""
    # 1. Create the first user
    response1 = await test_client.post("/api/v1/auth/register", json=user_credentials)
    assert response1.status_code == 201

    # 2. Attempt to create a second user with the same email
    payload2 = user_credentials.copy()
    payload2["username"] = "differentusername" # Use a different username
    response2 = await test_client.post("/api/v1/auth/register", json=payload2)

    # 3. Assert failure
    assert response2.status_code == 409
    assert "Email already registered" in response2.json()["detail"]


async def test_login_user_not_found(test_client: AsyncClient):
    """Ensures the API prevents login for a non-existent user."""
    login_payload = {"username": "nosuchuser", "password": "password"}
    response = await test_client.post("/api/v1/auth/login", data=login_payload)
    assert response.status_code == 401
    assert "Incorrect username or password" in response.json()["detail"]


async def test_login_incorrect_password(test_client: AsyncClient, user_credentials: dict):
    """Ensures the API prevents login with an incorrect password."""
    # 1. Register the user
    await test_client.post("/api/v1/auth/register", json=user_credentials)
    
    # 2. Attempt to log in with the wrong password
    login_payload = {
        "username": user_credentials["username"],
        "password": "wrong_password",
    }
    response = await test_client.post("/api/v1/auth/login", data=login_payload)
    assert response.status_code == 401
    assert "Incorrect username or password" in response.json()["detail"]


# --- Protected Endpoint Access Tests ---

async def test_access_protected_endpoint_no_token(test_client: AsyncClient):
    """Tests that accessing a protected endpoint without a token fails with 401."""
    response = await test_client.get("/api/v1/users/me") # No Authorization header
    assert response.status_code == 401
    assert response.json()["detail"] == "Not authenticated"


@pytest.mark.parametrize("bad_header", ["garbage", ""])
async def test_access_protected_endpoint_malformed_header(
    test_client: AsyncClient, bad_header: str
):
    """
    Tests that a completely malformed or empty Authorization header
    is rejected by the security scheme itself, returning "Not authenticated".
    """
    headers = {"Authorization": bad_header}
    response = await test_client.get("/api/v1/users/me", headers=headers)
    assert response.status_code == 401
    assert response.json()["detail"] == "Not authenticated"


@pytest.mark.parametrize("bad_header", ["Bearer ", "Bearer"])
async def test_access_protected_endpoint_empty_token(
    test_client: AsyncClient, bad_header: str
):
    """
    Tests that a header with the Bearer scheme but an empty token
    is passed to the decoding logic and fails, returning "Could not validate credentials".
    """
    headers = {"Authorization": bad_header}
    response = await test_client.get("/api/v1/users/me", headers=headers)
    assert response.status_code == 401
    assert "Could not validate credentials" in response.json()["detail"]








async def test_access_protected_endpoint_invalid_token(test_client: AsyncClient):


    """


    Tests that a structurally valid but garbage JWT (e.g., wrong signature)


    fails with 401 and "Could not validate credentials". This error is raised


    after the token is passed to the decoding function.


    """


    # A token that is structurally a JWT but has a garbage signature/payload


    bad_token = "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJ0ZXN0In0.fakerealsignature"


    headers = {"Authorization": bad_token}


    response = await test_client.get("/api/v1/users/me", headers=headers)


    assert response.status_code == 401


    assert "Could not validate credentials" in response.json()["detail"]
