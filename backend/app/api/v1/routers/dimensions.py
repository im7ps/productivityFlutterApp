from typing import List
from fastapi import APIRouter, Depends
from app.schemas.dimension import DimensionRead
from app.api.v1.deps import get_dimension_service
from app.services.dimension_service import DimensionService

router = APIRouter()

@router.get("/", response_model=List[DimensionRead])
async def read_dimensions(
    service: DimensionService = Depends(get_dimension_service)
):
    """
    Retrieve all dimensions (Energy, Clarity, Relationships, Soul).
    """
    return await service.get_all_dimensions()
