import uuid
from typing import List
from sqlmodel import Session
from app.models.action import Action
from app.repositories.action_repo import ActionRepo
from app.services.consultant_engine import ConsultantEngine

class ConsultantService:
    """
    Service for managing consultant-generated task proposals.
    Delegates complex selection logic to ConsultantEngine.
    """

    def __init__(self, session: Session):
        self.session = session
        self.action_repo = ActionRepo(session)
        self.engine = ConsultantEngine(self.action_repo)
    
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
        # Status is COMPLETED because in Day 0 logic, accepting from consultant
        # usually means it's done or being done immediately.
        new_action = Action(
            id=uuid.uuid4(),
            description=consumed_proposal.description,
            user_id=user_id,
            category=consumed_proposal.category,
            difficulty=consumed_proposal.difficulty,
            fulfillment_score=consumed_proposal.fulfillment_score,
            start_time=consumed_proposal.start_time,
            dimension_id=consumed_proposal.dimension_id,
            status="COMPLETED"
        )
        self.session.add(new_action)
        await self.session.commit()
        await self.session.refresh(new_action)
            
        return await self.get_proposals(user_id)
