import uuid
from typing import Generic, Type, TypeVar, List, Optional
from sqlalchemy.ext.asyncio import AsyncSession
from sqlmodel import SQLModel, select

# 1. Definiamo i nostri segnaposto (TypeVar)
ModelType = TypeVar("ModelType", bound=SQLModel)
CreateSchemaType = TypeVar("CreateSchemaType", bound=SQLModel)
UpdateSchemaType = TypeVar("UpdateSchemaType", bound=SQLModel)

# 2. Creiamo la classe base, rendendola "Generica"
class BaseRepository(Generic[ModelType, CreateSchemaType, UpdateSchemaType]):
    
    # 3. L'__init__ riceve il modello specifico con cui dovrà lavorare (es. Category)
    def __init__(self, model: Type[ModelType], session: AsyncSession):
        self.model = model
        self.session = session

    # 4. Implementiamo i metodi CRUD asincroni
    
    async def create(self, obj_in: CreateSchemaType, user_id: uuid.UUID) -> ModelType:
        """Questo metodo generico asincrono sostituisce create_category, create_activity_log, etc."""
        db_obj = self.model(**obj_in.model_dump(), user_id=user_id)
        self.session.add(db_obj)
        await self.session.commit()
        await self.session.refresh(db_obj)
        return db_obj

    async def get_by_id(self, obj_id: uuid.UUID, user_id: uuid.UUID) -> Optional[ModelType]:
        """Metodo generico asincrono per trovare un oggetto pelo suo ID e l'ID dell'utente."""
        statement = select(self.model).where(self.model.id == obj_id, self.model.user_id == user_id)
        result = await self.session.execute(statement)
        return result.scalars().first()

    async def get_all_by_user(self, user_id: uuid.UUID) -> List[ModelType]:
        """Metodo generico asincrono per trovare tutti gli oggetti di un utente."""
        statement = select(self.model).where(self.model.user_id == user_id)
        result = await self.session.execute(statement)
        return result.scalars().all()

    async def update(self, db_obj: ModelType, obj_in: UpdateSchemaType) -> ModelType:
        """Metodo generico asincrono per aggiornare un oggetto."""
        update_data = obj_in.model_dump(exclude_unset=True)
        for key, value in update_data.items():
            setattr(db_obj, key, value)
        self.session.add(db_obj)
        await self.session.commit()
        await self.session.refresh(db_obj)
        return db_obj

    async def delete(self, db_obj: ModelType) -> None:
        """Metodo generico asincrono per cancellare un oggetto."""
        await self.session.delete(db_obj)
        await self.session.commit()
