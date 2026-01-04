import uuid
from typing import List
from sqlmodel import Session, select
from app.models import Category
from app.schemas.category import CategoryCreate, CategoryUpdate

class CategoryRepository:
    def __init__(self, session: Session):
        self.session = session

    def create_category(self, category_create: CategoryCreate, user_id: uuid.UUID) -> Category:
        db_category = Category(
            **category_create.model_dump(),
            user_id=user_id
        )
        self.session.add(db_category)
        self.session.commit()
        self.session.refresh(db_category)
        return db_category

    def get_category_by_id(self, category_id: uuid.UUID, user_id: uuid.UUID) -> Category | None:
        statement = select(Category).where(Category.id == category_id, Category.user_id == user_id)
        return self.session.exec(statement).first()

    def get_all_categories_by_user(self, user_id: uuid.UUID) -> List[Category]:
        statement = select(Category).where(Category.user_id == user_id)
        return self.session.exec(statement).all()

    def update_category(self, category: Category, category_update: CategoryUpdate) -> Category:
        update_data = category_update.model_dump(exclude_unset=True)
        for key, value in update_data.items():
            setattr(category, key, value)
        
        self.session.add(category)
        self.session.commit()
        self.session.refresh(category)
        return category

    def delete_category(self, category: Category) -> None:
        self.session.delete(category)
        self.session.commit()
