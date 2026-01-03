from fastapi import APIRouter, Depends
from sqlmodel import Session
from app.database.session import get_session
from app.schemas.user_schema import CategoryCreate, CategoryRead
from app.models.user import User, Category
from typing import List
from app.api.v1.routers.auth import get_current_user
from sqlmodel import select

router = APIRouter()

@router.post("", response_model=CategoryRead)
def create_category(
    category_data: CategoryCreate,
    session: Session = Depends(get_session),
    current_user: User = Depends(get_current_user)
):
    category_dict = category_data.dict()
    category_dict["user_id"] = current_user.id

    new_category = Category(**category_dict)

    session.add(new_category)
    session.commit()
    session.refresh(new_category)

    return new_category

@router.get("", response_model=List[CategoryRead])
def read_categories(
    session: Session = Depends(get_session),
    current_user: User = Depends(get_current_user)
):
    statement = select(Category).where(Category.user_id == current_user.id)
    results = session.exec(statement).all()
    return results
