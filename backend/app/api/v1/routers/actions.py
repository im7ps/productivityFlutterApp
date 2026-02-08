from typing import List
from fastapi import APIRouter, Depends, status
from app.schemas.action import ActionRead, ActionCreate
from app.models.user import User
from app.api.v1.deps import get_current_active_user, get_action_service
from app.services.action_service import ActionService

router = APIRouter()

@router.post("/", response_model=ActionRead, status_code=status.HTTP_201_CREATED)
async def create_action(
    action_in: ActionCreate,
    current_user: User = Depends(get_current_active_user),
    service: ActionService = Depends(get_action_service),
):
    """
    Create a new action (activity log) for a specific dimension.
    """
    return await service.create_action(current_user.id, action_in)

@router.get("/", response_model=List[ActionRead])
async def read_actions(
    skip: int = 0,
    limit: int = 50,
    current_user: User = Depends(get_current_active_user),
    service: ActionService = Depends(get_action_service),
):
    """
    Retrieve user actions.
    """
    return await service.get_user_actions(current_user.id, skip=skip, limit=limit)
