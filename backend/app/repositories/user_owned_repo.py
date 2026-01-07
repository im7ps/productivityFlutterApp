import uuid
from typing import Generic, Type, TypeVar, List, Optional
from sqlalchemy.ext.asyncio import AsyncSession
from sqlmodel import SQLModel, select

# Generics per le entità possedute da un utente
ModelType = TypeVar("ModelType", bound=SQLModel)
CreateSchemaType = TypeVar("CreateSchemaType", bound=SQLModel)
UpdateSchemaType = TypeVar("UpdateSchemaType", bound=SQLModel)

class UserOwnedRepository(Generic[ModelType, CreateSchemaType, UpdateSchemaType]):
    """
    Repository base per entità che appartengono a un utente specifico.
    Presuppone che il modello abbia un campo 'user_id'.
    """
    def __init__(self, model: Type[ModelType], session: AsyncSession):
        self.model = model
        self.session = session

    async def create(self, obj_in: CreateSchemaType, user_id: uuid.UUID) -> ModelType:
        """Crea un record associandolo all'utente specificato."""
        db_obj = self.model(**obj_in.model_dump(), user_id=user_id)
        self.session.add(db_obj)
        await self.session.flush()
        await self.session.refresh(db_obj)
        return db_obj

    async def get_by_id(self, obj_id: uuid.UUID, user_id: uuid.UUID) -> Optional[ModelType]:
        """Recupera un oggetto solo se appartiene all'utente specificato."""
        statement = select(self.model).where(self.model.id == obj_id, self.model.user_id == user_id)
        result = await self.session.execute(statement)
        return result.scalars().first()

    async def get_all_by_user(self, user_id: uuid.UUID) -> List[ModelType]:
        """Recupera tutti gli oggetti di un utente."""
        statement = select(self.model).where(self.model.user_id == user_id)
        result = await self.session.execute(statement)
        return result.scalars().all()

    async def update(self, db_obj: ModelType, obj_in: UpdateSchemaType) -> ModelType:
        """Aggiorna un oggetto esistente."""
        update_data = obj_in.model_dump(exclude_unset=True)
        for key, value in update_data.items():
            setattr(db_obj, key, value)
        self.session.add(db_obj)
        await self.session.flush()
        await self.session.refresh(db_obj)
        return db_obj

    async def delete(self, db_obj: ModelType) -> None:
        """Cancella un oggetto esistente."""
        await self.session.delete(db_obj)
        await self.session.flush()
