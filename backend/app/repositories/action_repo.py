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
