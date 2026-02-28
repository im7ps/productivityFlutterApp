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
        print(f"DEBUG: DimensionService.get_dimension called with ID: '{dimension_id}'")
        dimension = await self.repo.get(dimension_id)
        if not dimension:
            print(f"DEBUG: DimensionService.get_dimension - Dimension NOT FOUND for ID: '{dimension_id}'")
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail=f"Dimension '{dimension_id}' not found"
            )
        print(f"DEBUG: DimensionService.get_dimension - Found: {dimension.name}")
        return dimension
