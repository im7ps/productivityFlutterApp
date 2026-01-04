from sqlmodel import Session
from app.models import Category
from app.schemas.category import CategoryCreate, CategoryUpdate
from .base_repo import BaseRepository


class CategoryRepository(BaseRepository[Category, CategoryCreate, CategoryUpdate]):
    def __init__(self, session: Session):
        super().__init__(model=Category, session=session)

