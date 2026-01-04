import uuid
from typing import Generic, Type, TypeVar, List, Optional
from sqlmodel import Session, SQLModel, select

# 1. Definiamo i nostri segnaposto (TypeVar)
ModelType = TypeVar("ModelType", bound=SQLModel)
CreateSchemaType = TypeVar("CreateSchemaType", bound=SQLModel)
UpdateSchemaType = TypeVar("UpdateSchemaType", bound=SQLModel)

# 2. Creiamo la classe base, rendendola "Generica"
class BaseRepository(Generic[ModelType, CreateSchemaType, UpdateSchemaType]):
    
    # 3. L'__init__ riceve il modello specifico con cui dovrà lavorare (es. Category)
    def __init__(self, model: Type[ModelType], session: Session):
        self.model = model
        self.session = session

    # 4. Implementiamo i metodi CRUD una sola volta, usando i segnaposto
    
    def create(self, obj_in: CreateSchemaType, user_id: uuid.UUID) -> ModelType:
        """Questo metodo generico sostituisce create_category, create_activity_log, etc."""
        db_obj = self.model(**obj_in.model_dump(), user_id=user_id)
        self.session.add(db_obj)
        self.session.commit()
        self.session.refresh(db_obj)
        return db_obj

    def get_by_id(self, obj_id: uuid.UUID, user_id: uuid.UUID) -> Optional[ModelType]:
        """Metodo generico per trovare un oggetto pelo suo ID e l'ID dell'utente."""
        statement = select(self.model).where(self.model.id == obj_id, self.model.user_id == user_id)
        return self.session.exec(statement).first()

    def get_all_by_user(self, user_id: uuid.UUID) -> List[ModelType]:
        """Metodo generico per trovare tutti gli oggetti di un utente."""
        statement = select(self.model).where(self.model.user_id == user_id)
        return self.session.exec(statement).all()

    def update(self, db_obj: ModelType, obj_in: UpdateSchemaType) -> ModelType:
        """Metodo generico per aggiornare un oggetto."""
        update_data = obj_in.model_dump(exclude_unset=True)
        for key, value in update_data.items():
            setattr(db_obj, key, value)
        self.session.add(db_obj)
        self.session.commit()
        self.session.refresh(db_obj)
        return db_obj

    def delete(self, db_obj: ModelType) -> None:
        """Metodo generico per cancellare un oggetto."""
        self.session.delete(db_obj)
        self.session.commit()
