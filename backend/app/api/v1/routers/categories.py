from fastapi import APIRouter, Depends, HTTPException
from sqlmodel import Session
import uuid
from app.database.session import get_session
from app.schemas.category import CategoryCreate, CategoryRead, CategoryUpdate
from app.models import User
from typing import List
from app.api.v1.routers.auth import get_current_user
from app.repositories import CategoryRepository

router = APIRouter()

def get_category_repo(session: Session = Depends(get_session)) -> CategoryRepository:
    return CategoryRepository(session)

@router.post("", response_model=CategoryRead)
def create_category(
    category_data: CategoryCreate,
    repo: CategoryRepository = Depends(get_category_repo),
    current_user: User = Depends(get_current_user)
):
    return repo.create(obj_in=category_data, user_id=current_user.id)

@router.get("", response_model=List[CategoryRead])
def read_categories(
    repo: CategoryRepository = Depends(get_category_repo),
    current_user: User = Depends(get_current_user)
):
    return repo.get_all_by_user(user_id=current_user.id)

@router.get("/{category_id}", response_model=CategoryRead)
def read_category(
    category_id: uuid.UUID,
    repo: CategoryRepository = Depends(get_category_repo),
    current_user: User = Depends(get_current_user)
):
    category = repo.get_by_id(obj_id=category_id, user_id=current_user.id)
    if not category:
        raise HTTPException(status_code=404, detail="Category not found")
    return category

@router.put("/{category_id}", response_model=CategoryRead)
def update_category(
    category_id: uuid.UUID,
    category_data: CategoryUpdate,
    repo: CategoryRepository = Depends(get_category_repo),
    current_user: User = Depends(get_current_user)
):
    category = repo.get_by_id(obj_id=category_id, user_id=current_user.id)
    if not category:
        raise HTTPException(status_code=404, detail="Category not found")
    return repo.update(db_obj=category, obj_in=category_data)

@router.delete("/{category_id}", status_code=204)
def delete_category(
    category_id: uuid.UUID,
    repo: CategoryRepository = Depends(get_category_repo),
    current_user: User = Depends(get_current_user)
):
    category = repo.get_by_id(obj_id=category_id, user_id=current_user.id)
    if not category:
        raise HTTPException(status_code=404, detail="Category not found")
    repo.delete(db_obj=category)
    return
