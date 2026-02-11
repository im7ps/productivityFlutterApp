import pytest
from httpx import AsyncClient
from sqlmodel import select
from sqlalchemy.ext.asyncio import AsyncSession
from app.models.action import Action
from app.models.user import User
from fastapi import status

@pytest.mark.asyncio
async def test_consume_consultant_proposal_unauthenticated(test_client: AsyncClient):
    """Test that an unauthenticated user cannot consume a consultant proposal."""
    print("DEBUG_TEST: test_consume_consultant_proposal_unauthenticated started.")
    # Need a valid UUID for the path, even if unauthenticated
    dummy_uuid = "00000000-0000-0000-0000-000000000001" 
    response = await test_client.post(f"/api/v1/consultant/proposals/{dummy_uuid}/consume")
    print(f"DEBUG_TEST: Response status code: {response.status_code}")
    assert response.status_code == status.HTTP_401_UNAUTHORIZED
    print("DEBUG_TEST: test_consume_consultant_proposal_unauthenticated finished successfully.")

@pytest.mark.asyncio
async def test_consume_valid_consultant_proposal(
    authenticated_client: AsyncClient,
    test_user: User,
    db_session: AsyncSession # Corrected fixture name
):
    """Test that an authenticated user can consume a valid consultant proposal."""
    # 1. Get initial proposals
    response = await authenticated_client.get("/api/v1/consultant/proposals")
    assert response.status_code == status.HTTP_200_OK
    initial_proposals = response.json()
    assert len(initial_proposals) == 5

    # Choose one to consume
    proposal_to_consume = initial_proposals[0]
    proposal_id = proposal_to_consume["id"]

    # 2. Consume the proposal
    response = await authenticated_client.post(
        f"/api/v1/consultant/proposals/{proposal_id}/consume"
    )
    assert response.status_code == status.HTTP_200_OK
    new_proposals = response.json()
    assert isinstance(new_proposals, list)
    assert len(new_proposals) == 5 # Still expect 5 proposals

    # 3. Verify the consumed proposal is no longer in the new set
    assert not any(p["id"] == proposal_id for p in new_proposals)

    # 4. Verify the consumed proposal was added as a user action in the DB
    result = await db_session.execute(
        select(Action).where(
            Action.user_id == test_user.id,
            Action.description == proposal_to_consume["description"]
        )
    )
    saved_action = result.scalars().first()
    assert saved_action is not None
    assert saved_action.status == "COMPLETED" 

@pytest.mark.asyncio
async def test_consume_invalid_consultant_proposal(authenticated_client: AsyncClient):
    """Test consuming an invalid proposal ID returns a 404."""
    invalid_uuid = "ffffffff-ffff-ffff-ffff-ffffffffffff" 
    response = await authenticated_client.post(
        f"/api/v1/consultant/proposals/{invalid_uuid}/consume"
    )
    assert response.status_code == status.HTTP_404_NOT_FOUND
