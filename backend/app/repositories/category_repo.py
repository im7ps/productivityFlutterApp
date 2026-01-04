from sqlalchemy.ext.asyncio import AsyncSession
from app.models import Category
from app.schemas.category import CategoryCreate, CategoryUpdate
from .base_repo import BaseRepository


class CategoryRepository(BaseRepository[Category, CategoryCreate, CategoryUpdate]):
    def __init__(self, session: AsyncSession):
        super().__init__(model=Category, session=session)