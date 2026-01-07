from typing import List
import uuid

from app.core.exceptions import ResourceNotFound
from app.models.category import Category
from app.repositories.category_repo import CategoryRepository
from app.schemas.category import CategoryCreate, CategoryUpdate
from sqlalchemy.ext.asyncio import AsyncSession


class CategoryService:
    def __init__(self, session: AsyncSession, category_repo: CategoryRepository):
        self.session = session
        self.category_repo = category_repo

    async def create_category(self, category_create: CategoryCreate, user_id: uuid.UUID) -> Category:
        """
        Create a new category for the user.
        """
        category = await self.category_repo.create(obj_in=category_create, user_id=user_id)
        await self.session.commit()
        return category

    async def get_categories_by_user(self, user_id: uuid.UUID) -> List[Category]:
        """
        Retrieve all categories belonging to the user.
        """
        return await self.category_repo.get_all_by_user(user_id=user_id)

    async def get_category_by_id(self, category_id: uuid.UUID, user_id: uuid.UUID) -> Category:
        """
        Retrieve a specific category by ID and user ID.
        Raises ResourceNotFound if the category does not exist.
        """
        category = await self.category_repo.get_by_id(obj_id=category_id, user_id=user_id)
        if not category:
            raise ResourceNotFound(f"Category with id {category_id} not found")
        return category

    async def update_category(
        self, category_id: uuid.UUID, category_update: CategoryUpdate, user_id: uuid.UUID
    ) -> Category:
        """
        Update an existing category.
        Raises ResourceNotFound if the category does not exist.
        """
        # Ensure category exists and belongs to user
        category = await self.get_category_by_id(category_id, user_id)
        updated_category = await self.category_repo.update(db_obj=category, obj_in=category_update)
        await self.session.commit()
        return updated_category

    async def delete_category(self, category_id: uuid.UUID, user_id: uuid.UUID) -> None:
        """
        Delete a category.
        Raises ResourceNotFound if the category does not exist.
        """
        # Ensure category exists and belongs to user
        category = await self.get_category_by_id(category_id, user_id)
        await self.category_repo.delete(db_obj=category)
        await self.session.commit()
