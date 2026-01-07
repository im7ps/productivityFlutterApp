import uuid
from sqlmodel import SQLModel, Field, Relationship
from typing import Optional, List, TYPE_CHECKING

if TYPE_CHECKING:
    from app.models.user import User
    from app.models.activity_log import ActivityLog

# --- CATEGORIE ---
class Category(SQLModel, table=True):
    id: uuid.UUID = Field(default_factory=uuid.uuid4, primary_key=True)
    name: str
    icon: str = Field(default="circle")
    color: str = Field(default="blue")

    user_id: uuid.UUID = Field(foreign_key="user.id", index=True)
    user: Optional["User"] = Relationship(back_populates="categories")

    activities: List["ActivityLog"] = Relationship(back_populates="category")
