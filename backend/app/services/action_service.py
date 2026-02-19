import uuid
from typing import List
from fastapi import HTTPException, status
from app.models.action import Action
from app.schemas.action import ActionCreate, ActionUpdate
from app.repositories.action_repo import ActionRepo
from app.services.dimension_service import DimensionService

class ActionService:
    def __init__(self, repo: ActionRepo, dimension_service: DimensionService):
        self.repo = repo
        self.dimension_service = dimension_service

    async def create_action(self, user_id: uuid.UUID, action_in: ActionCreate) -> Action:
        # Verify dimension exists
        dim = await self.dimension_service.get_dimension(action_in.dimension_id)
        if not dim:
             raise HTTPException(status_code=404, detail="Dimension not found")
             
        action = await self.repo.create_for_user(user_id, action_in)
        # --- FIX: AGGIUNTO COMMIT PER PERSISTENZA ---
        await self.repo.session.commit()
        
        # Manually populate the relationship to avoid MissingGreenlet error on serialization
        action.dimension = dim 
        return action

    async def get_user_actions(self, user_id: uuid.UUID, skip: int = 0, limit: int = 50) -> List[Action]:
        return await self.repo.get_recent_by_user(user_id, limit=limit, skip=skip)

    async def get_user_portfolio(self, user_id: uuid.UUID) -> List[Action]:
        """
        Retrieves unique actions that the user has successfully completed.
        """
        return await self.repo.get_unique_completed_actions(user_id)
        
    async def delete_action(self, user_id: uuid.UUID, action_id: uuid.UUID) -> bool:
        return await self.repo.delete_for_user(user_id, action_id)
