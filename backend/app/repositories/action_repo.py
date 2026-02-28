from typing import List
import uuid
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.orm import selectinload
from sqlmodel import select, desc
from app.models.action import Action
from app.schemas.action import ActionCreate, ActionUpdate
from app.repositories.user_owned_repo import UserOwnedRepo

class ActionRepo(UserOwnedRepo[Action, ActionCreate, ActionUpdate]):
    def __init__(self, session: AsyncSession):
        super().__init__(model=Action, session=session)

    async def get_recent_by_user(
        self, 
        user_id: uuid.UUID, 
        limit: int = 50, 
        skip: int = 0
    ) -> List[Action]:
        statement = (
            select(self.model)
            .options(selectinload(self.model.dimension))
            .where(self.model.user_id == user_id)
            .order_by(desc(self.model.start_time))
            .offset(skip)
            .limit(limit)
        )
        # result = await self.session.exec(statement) # SQLModel .exec is for Sync, for AsyncSession use .execute
        result = await self.session.execute(statement)
        return result.scalars().all()

    async def get_unique_completed_actions(self, user_id: uuid.UUID) -> List[Action]:
        """
        Returns a list of unique actions (by description) that the user has COMPLETED or are IN_PROGRESS.
        This represents the user's "Portfolio" and "Active Identity".
        """
        print(f"DEBUG: ActionRepo.get_unique_completed_actions - Fetching for user {user_id}")
        from sqlalchemy import func, or_
        
        subquery = (
            select(
                self.model.description,
                func.max(self.model.start_time).label("max_time")
            )
            .where(self.model.user_id == user_id)
            .where(or_(self.model.status == "COMPLETED", self.model.status == "IN_PROGRESS"))
            .group_by(self.model.description)
            .subquery()
        )
        
        statement = (
            select(self.model)
            .join(
                subquery,
                (self.model.description == subquery.c.description) & 
                (self.model.start_time == subquery.c.max_time)
            )
            .where(self.model.user_id == user_id)
            .options(selectinload(self.model.dimension))
        )
        
        result = await self.session.execute(statement)
        actions = result.scalars().all()
        print(f"DEBUG: ActionRepo.get_unique_completed_actions - FOUND {len(actions)} unique actions")
        return list(actions)
