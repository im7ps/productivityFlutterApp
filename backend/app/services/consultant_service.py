import uuid
from typing import List
from sqlmodel import Session
from app.models.action import Action
from app.schemas.action import ActionCreate
from app.services.action_service import ActionService
from app.services.consultant_engine import ConsultantEngine

class ConsultantService:
    """
    Service for managing consultant-generated task proposals.
    Delegates complex selection logic to ConsultantEngine.
    """

    def __init__(self, action_service: ActionService, engine: ConsultantEngine):
        self.action_service = action_service
        self.engine = engine
    
    async def get_proposals(self, user_id: uuid.UUID) -> List[Action]:
        """
        Retrieves the task proposals for a user using the ConsultantEngine.
        """
        return await self.engine.generate_proposals(user_id)

    async def consume_proposal(self, user_id: uuid.UUID, proposal_id: uuid.UUID) -> List[Action]:
        """
        Consumes a proposal and returns a fresh set of proposals.
        """
        # Re-generate current proposals to find the one to consume
        current_proposals = await self.get_proposals(user_id)
        consumed_proposal = next((p for p in current_proposals if p.id == proposal_id), None)

        if not consumed_proposal:
            raise ValueError(f"Consultant proposal with ID {proposal_id} not found.")
            
        # Create a new Action instance based on the consumed proposal
        # Use ActionCreate schema to pass data to action_service
        action_in = ActionCreate(
            description=consumed_proposal.description,
            category=consumed_proposal.category,
            difficulty=consumed_proposal.difficulty,
            fulfillment_score=consumed_proposal.fulfillment_score,
            dimension_id=consumed_proposal.dimension_id,
            status="COMPLETED"
        )
        
        await self.action_service.create_action(user_id=user_id, action_in=action_in)
            
        return await self.get_proposals(user_id)
