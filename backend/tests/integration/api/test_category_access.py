import pytest
from httpx import AsyncClient
import uuid

from app.repositories import UserRepository # For direct DB interaction in tests
from app.models import User # For type hinting

# Mark all tests in this file as async and needing a DB connection
pytestmark = [pytest.mark.asyncio, pytest.mark.db]


# --- Helper Fixtures ---

@pytest.fixture
def create_user_and_login(test_client: AsyncClient):
    """
    A helper fixture factory that creates a new user, registers them,
    and returns their auth headers.
    """
    async def _create_user_and_login(username_suffix: str) -> dict:
        user_credentials = {
            "username": f"catuser{username_suffix}",
            "email": f"cat_user_{username_suffix}@example.com",
            "password": "ValidPassword123!",
        }
        
        # Register
        reg_response = await test_client.post("/api/v1/auth/register", json=user_credentials)
        assert reg_response.status_code == 201
        user_id = reg_response.json()["id"]

        # Login
        login_payload = {
            "username": user_credentials["username"],
            "password": user_credentials["password"],
        }
        log_response = await test_client.post("/api/v1/auth/login", data=login_payload)
        assert log_response.status_code == 200
        token = log_response.json()["access_token"]
        
        return {
            "headers": {"Authorization": f"Bearer {token}"},
            "user_id": user_id
        }

    return _create_user_and_login


# --- API Tests ---

async def test_category_crud_lifecycle(test_client: AsyncClient, create_user_and_login):
    """Tests the full Create, Read, Update, Delete lifecycle for categories."""
    # 1. Setup: Create and log in a user
    user_a_context = await create_user_and_login("crud")
    headers = user_a_context["headers"]

    # 2. Create
    create_payload = {"name": "Work", "color": "blue"}
    response = await test_client.post("/api/v1/categories", json=create_payload, headers=headers)
    assert response.status_code == 200
    category_data = response.json()
    assert category_data["name"] == "Work"
    category_id = category_data["id"]

    # 3. Read (Single and All)
    response = await test_client.get(f"/api/v1/categories/{category_id}", headers=headers)
    assert response.status_code == 200
    assert response.json()["name"] == "Work"

    response = await test_client.get("/api/v1/categories", headers=headers)
    assert response.status_code == 200
    assert len(response.json()) == 1
    assert response.json()[0]["name"] == "Work"

    # 4. Update
    update_payload = {"name": "Work-Updated", "color": "red"}
    response = await test_client.put(f"/api/v1/categories/{category_id}", json=update_payload, headers=headers)
    assert response.status_code == 200
    assert response.json()["name"] == "Work-Updated"
    assert response.json()["color"] == "red"

    # 5. Delete
    response = await test_client.delete(f"/api/v1/categories/{category_id}", headers=headers)
    assert response.status_code == 204

    # Verify Deletion
    response = await test_client.get(f"/api/v1/categories/{category_id}", headers=headers)
    assert response.status_code == 404


async def test_multi_tenancy_isolation(test_client: AsyncClient, create_user_and_login):
    """
    CRITICAL: Ensures one user cannot access, modify, or delete another user's resources.
    Asserts that the API returns 404 Not Found, not 403 Forbidden, to prevent ID guessing.
    """
    # 1. Setup: Create two separate, logged-in users
    user_a = await create_user_and_login("A")
    user_b = await create_user_and_login("B")

    # 2. User A creates a category
    create_payload = {"name": "User A's Private Category"}
    response = await test_client.post("/api/v1/categories", json=create_payload, headers=user_a["headers"])
    assert response.status_code == 200
    category_id_A = response.json()["id"]

    # 3. User B attempts to access User A's category and fails with 404
    # GET
    response = await test_client.get(f"/api/v1/categories/{category_id_A}", headers=user_b["headers"])
    assert response.status_code == 404
    assert "not found" in response.json()["detail"]
    
    # UPDATE
    update_payload = {"name": "Hacked by User B"}
    response = await test_client.put(f"/api/v1/categories/{category_id_A}", json=update_payload, headers=user_b["headers"])
    assert response.status_code == 404
    assert "not found" in response.json()["detail"]

    # DELETE
    response = await test_client.delete(f"/api/v1/categories/{category_id_A}", headers=user_b["headers"])
    assert response.status_code == 404
    assert "not found" in response.json()["detail"]

    # 4. Verify User A's category was not affected
    response = await test_client.get(f"/api/v1/categories/{category_id_A}", headers=user_a["headers"])
    assert response.status_code == 200
    assert response.json()["name"] == "User A's Private Category"


@pytest.mark.parametrize("method, endpoint_suffix", [
    ("GET", ""),
    ("PUT", ""),
    ("DELETE", ""),
])
async def test_access_nonexistent_category(test_client: AsyncClient, create_user_and_login, method: str, endpoint_suffix: str):
    """Tests that accessing a non-existent UUID returns a 404."""
    user = await create_user_and_login("edgecase")
    non_existent_id = uuid.uuid4()
    
    url = f"/api/v1/categories/{non_existent_id}{endpoint_suffix}"
    
    response = await test_client.request(method, url, headers=user["headers"], json={"name": "update"} if method == "PUT" else None)
    
    assert response.status_code == 404


async def test_mass_assignment_vulnerability(test_client: AsyncClient, create_user_and_login, db_session):
    """
    Tests for mass assignment vulnerability by attempting to change the user_id of a category.
    The update operation should ignore the 'user_id' field in the payload.
    """
    # 1. Setup: Create two users
    user_a = await create_user_and_login("owner")
    user_b = await create_user_and_login("victim")

    # 2. User A creates a category
    create_payload = {"name": "User A's Category"}
    response = await test_client.post("/api/v1/categories", json=create_payload, headers=user_a["headers"])
    assert response.status_code == 200
    category = response.json()
    category_id = category["id"]

    # 3. User A attempts to re-assign the category to User B via mass assignment
    malicious_payload = {
        "name": "Re-assigned Category",
        "user_id": user_b["user_id"]  # Attempting to change ownership
    }
    response = await test_client.put(f"/api/v1/categories/{category_id}", json=malicious_payload, headers=user_a["headers"])
    assert response.status_code == 200 # The request is valid from User A's perspective
    
    # 4. CRITICAL: Verify the user_id was NOT changed in the database
    # We need to bypass the API's tenancy checks to see the true state of the object.
    from app.models import Category
    from sqlmodel import select
    
    await db_session.flush() # Ensure the transaction is synchronized
    
    stmt = select(Category).where(Category.id == category_id)
    result = await db_session.execute(stmt)
    updated_category_from_db = result.scalars().one()
    
    assert updated_category_from_db is not None
    # The owner should still be User A
    assert str(updated_category_from_db.user_id) == user_a["user_id"]
    # The name should be updated
    assert updated_category_from_db.name == "Re-assigned Category"
