import pytest
from httpx import AsyncClient
import uuid

from app.repositories import UserRepository
from app.models import User

# Mark all tests in this file as async and needing a DB connection
pytestmark = [pytest.mark.asyncio, pytest.mark.db]


# --- API Tests ---

async def test_category_crud_lifecycle(test_client: AsyncClient, auth_user_context):
    """Tests the full Create, Read, Update, Delete lifecycle for categories."""
    # 1. Setup: Create and log in a user
    user_a_context = await auth_user_context("crud")
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


async def test_multi_tenancy_isolation(test_client: AsyncClient, auth_user_context):
    """
    CRITICAL: Ensures one user cannot access, modify, or delete another user's resources.
    Asserts that the API returns 404 Not Found, not 403 Forbidden, to prevent ID guessing.
    """
    # 1. Setup: Create two separate, logged-in users
    user_a = await auth_user_context("A")
    user_b = await auth_user_context("B")

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
async def test_access_nonexistent_category(test_client: AsyncClient, auth_user_context, method: str, endpoint_suffix: str):
    """Tests that accessing a non-existent UUID returns a 404."""
    user = await auth_user_context("edgecase")
    non_existent_id = uuid.uuid4()
    
    url = f"/api/v1/categories/{non_existent_id}{endpoint_suffix}"
    
    response = await test_client.request(method, url, headers=user["headers"], json={"name": "update"} if method == "PUT" else None)
    
    assert response.status_code == 404


async def test_mass_assignment_vulnerability(test_client: AsyncClient, auth_user_context, db_session):
    """
    Tests for mass assignment vulnerability by attempting to change the user_id of a category.
    The update operation should ignore the 'user_id' field in the payload.
    """
    # 1. Setup: Create two users
    user_a = await auth_user_context("owner")
    user_b = await auth_user_context("victim")

    # 2. User A creates a category
    create_payload = {"name": "User A's Category"}
    response = await test_client.post("/api/v1/categories", json=create_payload, headers=user_a["headers"])
    assert response.status_code == 200
    category = response.json()
    category_id = category["id"]

    # 3. User A attempts to re-assign the category to User B via mass assignment
    malicious_payload = {
        "name": "Re-assigned Category",
        "user_id": user_b["user_id"]  # Attempting to change ownership (Forbidden field)
    }
    response = await test_client.put(f"/api/v1/categories/{category_id}", json=malicious_payload, headers=user_a["headers"])
    
    # NOW: The request should fail because 'user_id' is not a permitted field in the schema (extra='forbid')
    assert response.status_code == 422
    assert "extra_forbidden" in response.text.lower() or "extra fields not permitted" in response.text.lower()
    
    # 4. CRITICAL: Verify the database state remains unchanged for protected fields
    from app.models import Category
    from sqlmodel import select
    
    await db_session.flush() # Ensure the transaction is synchronized
    
    stmt = select(Category).where(Category.id == category_id)
    result = await db_session.execute(stmt)
    category_from_db = result.scalars().one()
    
    # The owner must still be User A
    assert str(category_from_db.user_id) == user_a["user_id"]
    # The name should NOT have been updated (because the whole request failed)
    assert category_from_db.name == "User A's Category"