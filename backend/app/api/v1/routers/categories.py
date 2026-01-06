from fastapi import APIRouter, Depends
from sqlalchemy.ext.asyncio import AsyncSession
import uuid
from typing import List

from app.database.session import get_session
from app.schemas.category import CategoryCreate, CategoryRead, CategoryUpdate
from app.api.v1.deps import CurrentUser
from app.repositories.category_repo import CategoryRepository
from app.services.category_service import CategoryService

router = APIRouter()

def get_category_service(session: AsyncSession = Depends(get_session)) -> CategoryService:
    repo = CategoryRepository(session)
    return CategoryService(repo)

@router.post("", response_model=CategoryRead)
async def create_category(
    category_data: CategoryCreate,
    current_user: CurrentUser,
    service: CategoryService = Depends(get_category_service)
):
    return await service.create_category(category_create=category_data, user_id=current_user.id)

@router.get("", response_model=List[CategoryRead])
async def read_categories(
    current_user: CurrentUser,
    service: CategoryService = Depends(get_category_service)
):
    return await service.get_categories_by_user(user_id=current_user.id)

@router.get("/{category_id}", response_model=CategoryRead)
async def read_category(
    category_id: uuid.UUID,
    current_user: CurrentUser,
    service: CategoryService = Depends(get_category_service)
):
    return await service.get_category_by_id(category_id=category_id, user_id=current_user.id)

@router.put("/{category_id}", response_model=CategoryRead)
async def update_category(
    category_id: uuid.UUID,
    category_data: CategoryUpdate,
    current_user: CurrentUser,
    service: CategoryService = Depends(get_category_service)
):
    return await service.update_category(
        category_id=category_id, category_update=category_data, user_id=current_user.id
    )

@router.delete("/{category_id}", status_code=204)
async def delete_category(
    category_id: uuid.UUID,
    current_user: CurrentUser,
    service: CategoryService = Depends(get_category_service)
):
    await service.delete_category(category_id=category_id, user_id=current_user.id)