import pytest
from httpx import AsyncClient
from app.models.user import User
from fastapi import status

@pytest.mark.asyncio
async def test_get_consultant_proposals_unauthenticated(test_client: AsyncClient):
    """Test that an unauthenticated user cannot get consultant proposals."""
    response = await test_client.get("/api/v1/consultant/proposals")
    assert response.status_code == status.HTTP_401_UNAUTHORIZED

@pytest.mark.asyncio
async def test_get_consultant_proposals_authenticated(
    authenticated_client: AsyncClient,
    test_user: User 
):
    """Test that an authenticated user can get consultant proposals."""
    print("DEBUG_TEST: test_get_consultant_proposals_authenticated started.")
    response = await authenticated_client.get("/api/v1/consultant/proposals")
    print(f"DEBUG_TEST: Response status code: {response.status_code}")
    print(f"DEBUG_TEST: Response JSON: {response.json()}")
    assert response.status_code == status.HTTP_200_OK
    proposals = response.json()
    assert isinstance(proposals, list)
    assert len(proposals) == 5 # Expect 5 proposals as per current implementation

    for proposal in proposals:
        assert "id" in proposal
        assert "description" in proposal
        assert "category" in proposal
        assert "difficulty" in proposal
        assert "fulfillment_score" in proposal
        assert "user_id" in proposal
        assert proposal["user_id"] == str(test_user.id) # Ensure proposals are for the test user
    print("DEBUG_TEST: test_get_consultant_proposals_authenticated finished successfully.")
