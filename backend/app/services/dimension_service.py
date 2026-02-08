import uuid
from typing import List
from fastapi import HTTPException, status
from app.models.dimension import Dimension
from app.repositories.dimension_repo import DimensionRepo

class DimensionService:
    def __init__(self, repo: DimensionRepo):
        self.repo = repo

    async def get_all_dimensions(self) -> List[Dimension]:
        return await self.repo.get_all()

    async def get_dimension(self, dimension_id: str) -> Dimension:
        dimension = await self.repo.get(dimension_id)
        if not dimension:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail="Dimension not found"
            )
        return dimension
