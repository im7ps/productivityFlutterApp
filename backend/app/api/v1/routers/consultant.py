import uuid
from typing import List
from fastapi import APIRouter, Depends, HTTPException, status

from app.api.v1.deps import get_consultant_service, get_current_active_user
from app.models.action import Action
from app.models.user import User
from app.services.consultant_service import ConsultantService

router = APIRouter()

@router.get("/proposals", response_model=List[Action])
async def get_consultant_proposals(
    current_user: User = Depends(get_current_active_user),
    consultant_service: ConsultantService = Depends(get_consultant_service)
):
    """
    Retrieve the current list of 5 consultant proposals for the authenticated user.
    """
    proposals = await consultant_service.get_proposals(current_user.id)
    return proposals

@router.post("/proposals/{proposal_id}/consume", response_model=List[Action])
async def consume_consultant_proposal(
    proposal_id: uuid.UUID,
    current_user: User = Depends(get_current_active_user),
    consultant_service: ConsultantService = Depends(get_consultant_service)
):
    """
    Consume a specific consultant proposal, add it to the user's tasks,
    and get a new set of 5 proposals.
    """
    try:
        new_proposals = await consultant_service.consume_proposal(current_user.id, proposal_id)
        return new_proposals
    except ValueError as e:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail=str(e))
    except Exception as e:
        raise HTTPException(status_code=status.HTTP_500_INTERNAL_SERVER_ERROR, detail=str(e))
