from typing import Generic, Type, TypeVar, List, Any
from sqlalchemy.ext.asyncio import AsyncSession
from sqlmodel import SQLModel

ModelType = TypeVar("ModelType", bound=SQLModel)
CreateSchemaType = TypeVar("CreateSchemaType", bound=SQLModel)
UpdateSchemaType = TypeVar("UpdateSchemaType", bound=SQLModel)

class BaseRepo(Generic[ModelType, CreateSchemaType, UpdateSchemaType]):
    """
    Base generic repository implementing common CRUD operations.
    """
    def __init__(self, model: Type[ModelType], session: AsyncSession):
        self.model = model
        self.session = session

    async def create_batch(self, objs_in: List[CreateSchemaType], **kwargs: Any) -> List[ModelType]:
        """
        Creates multiple records in a batch.
        Accepts kwargs to set common attributes (e.g., user_id) for all records.
        """
        db_objs = [
            self.model(**obj.model_dump(), **kwargs)
            for obj in objs_in
        ]
        self.session.add_all(db_objs)
        await self.session.flush()
        # Note: We do NOT refresh individually for performance reasons in batch ops.
        return db_objs

    async def update(self, db_obj: ModelType, obj_in: UpdateSchemaType) -> ModelType:
        """Updates an existing record."""
        update_data = obj_in.model_dump(exclude_unset=True)
        for key, value in update_data.items():
            setattr(db_obj, key, value)
        self.session.add(db_obj)
        await self.session.flush()
        await self.session.refresh(db_obj)
        return db_obj

    async def delete(self, db_obj: ModelType) -> None:
        """Deletes an existing record."""
        await self.session.delete(db_obj)
        await self.session.flush()
