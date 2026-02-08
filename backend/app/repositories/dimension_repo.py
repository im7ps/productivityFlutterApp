from typing import List, Optional
from sqlalchemy.ext.asyncio import AsyncSession
from sqlmodel import select
from app.models.dimension import Dimension
from app.repositories.base_repo import BaseRepo

class DimensionRepo(BaseRepo[Dimension, Dimension, Dimension]): 
    """
    Repository for fixed Dimensions.
    Mainly for read operations as they are seeded.
    """
    def __init__(self, session: AsyncSession):
        super().__init__(model=Dimension, session=session)

    async def get_by_name(self, name: str) -> Optional[Dimension]:
        statement = select(self.model).where(self.model.name == name)
        result = await self.session.execute(statement)
        return result.scalars().first()
        
    async def get_all(self) -> List[Dimension]:
        statement = select(self.model)
        result = await self.session.execute(statement)
        return result.scalars().all()

    async def get(self, id: str) -> Optional[Dimension]:
        """Retrieve dimension by slug ID."""
        statement = select(self.model).where(self.model.id == id)
        result = await self.session.execute(statement)
        return result.scalars().first()
