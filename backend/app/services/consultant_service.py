import uuid
from typing import List, Optional
from datetime import datetime
from sqlmodel import Session, select

from app.models.action import Action
from app.models.user import User # Potentially useful for user-specific logic
from app.models.dimension import Dimension

class ConsultantService:
    """
    Service for managing consultant-generated task proposals.
    """

    def __init__(self, session: Session):
        self.session = session
    
    async def get_proposals(self, user_id: uuid.UUID) -> List[Action]:
        """
        Retrieves the 5 current consultant proposals for a user.
        Filters out tasks already completed by the user today.
        """
        print(f"DEBUG_SERVICE: get_proposals called for user {user_id}")
        
        # 1. Fetch completed actions for today to avoid duplicates
        today_start = datetime.utcnow().replace(hour=0, minute=0, second=0, microsecond=0)
        result_actions = await self.session.execute(
            select(Action).where(
                Action.user_id == user_id,
                Action.status == "COMPLETED",
                Action.start_time >= today_start
            )
        )
        completed_descriptions = {a.description for a in result_actions.scalars().all()}

        # 2. Fetch dimensions
        result_dims = await self.session.execute(select(Dimension))
        dimensions = result_dims.scalars().all()
        dimension_map = {d.id: d.id for d in dimensions}

        default_dimension_id = dimensions[0].id if dimensions else None

        # 3. Define potential pool of proposals
        pool = [
            {
                "id_suffix": "1",
                "description": "Suonare Chitarra per 30 minuti",
                "category": "Passione",
                "difficulty": 2,
                "fulfillment_score": 4,
                "slug": "passione"
            },
            {
                "id_suffix": "2",
                "description": "Pulire Scrivania",
                "category": "Dovere",
                "difficulty": 3,
                "fulfillment_score": 3,
                "slug": "dovere"
            },
            {
                "id_suffix": "3",
                "description": "Corsa 5km",
                "category": "Energia",
                "difficulty": 5,
                "fulfillment_score": 4,
                "slug": "energia"
            },
            {
                "id_suffix": "4",
                "description": "Meditazione 15 minuti",
                "category": "Energia",
                "difficulty": 1,
                "fulfillment_score": 4,
                "slug": "energia"
            },
            {
                "id_suffix": "5",
                "description": "Chiamare un Amico/a",
                "category": "Relazioni",
                "difficulty": 1,
                "fulfillment_score": 4,
                "slug": "relazioni"
            },
            {
                "id_suffix": "6",
                "description": "Leggere 10 pagine",
                "category": "Anima",
                "difficulty": 2,
                "fulfillment_score": 5,
                "slug": "anima"
            },
            {
                "id_suffix": "7",
                "description": "Pianificare Domani",
                "category": "Dovere",
                "difficulty": 1,
                "fulfillment_score": 3,
                "slug": "dovere"
            }
        ]

        # 4. Filter and take 5
        available = [p for p in pool if p["description"] not in completed_descriptions]
        selected = available[:5]

        proposals = []
        for p in selected:
            # Use a deterministic UUID based on user and task to keep it stable across calls
            # unless the task is completed (which filters it out)
            proposal_id = uuid.uuid5(uuid.NAMESPACE_DNS, f"{user_id}-{p['id_suffix']}")
            proposals.append(
                Action(
                    id=proposal_id,
                    description=p["description"],
                    user_id=user_id,
                    category=p["category"],
                    difficulty=p["difficulty"],
                    fulfillment_score=p["fulfillment_score"],
                    start_time=datetime.utcnow(),
                    dimension_id=dimension_map.get(p["slug"], default_dimension_id),
                )
            )

        print(f"DEBUG_SERVICE: Proposals before return: {[p.id for p in proposals]}")
        return proposals

    async def consume_proposal(self, user_id: uuid.UUID, proposal_id: uuid.UUID) -> List[Action]:
        """
        Consumes a proposal (adds it as a regular action) and generates a new set of 5 proposals.
        """
        print(f"DEBUG: Proposal {proposal_id} consumed by user {user_id}. Re-generating proposals.")
        
        # Generate the initial list of proposals to "find" the consumed one
        # In a real scenario, proposals would be persisted in a temporary store
        # and retrieved from there to ensure consistency.
        current_proposals = await self.get_proposals(user_id)
        print(f"DEBUG_SERVICE: current_proposals for consume_proposal: {[p.id for p in current_proposals]}")
        print(f"DEBUG_SERVICE: Looking for proposal_id: {proposal_id}")
        consumed_proposal = next((p for p in current_proposals if p.id == proposal_id), None)

        if not consumed_proposal:
            print(f"DEBUG_SERVICE: Proposal {proposal_id} NOT FOUND.")
            # If proposal not found, raise an error that will be caught by the router
            raise ValueError(f"Consultant proposal with ID {proposal_id} not found.")
            
        # Create a new Action instance based on the consumed proposal
        new_action = Action(
            id=uuid.uuid4(), # Assign a new UUID for the actual action being saved
            description=consumed_proposal.description,
            user_id=user_id,
            category=consumed_proposal.category,
            difficulty=consumed_proposal.difficulty,
            fulfillment_score=consumed_proposal.fulfillment_score,
            start_time=datetime.utcnow(),
            dimension_id=consumed_proposal.dimension_id,
            status="COMPLETED" # Mark as completed upon consumption
        )
        self.session.add(new_action)
        await self.session.commit()
        await self.session.refresh(new_action)
        print(f"DEBUG: Saved consumed proposal as new action: {new_action.id}")
            
        # Then generate and return a new set of proposals
        return await self.get_proposals(user_id)
