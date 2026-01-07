import uuid
from sqlmodel import SQLModel, Field, Relationship
from typing import Optional, TYPE_CHECKING
from datetime import datetime
from app.models.utils import get_utc_now

if TYPE_CHECKING:
    from app.models.user import User
    from app.models.category import Category

# --- LOG ATTIVITÀ ---
class ActivityLog(SQLModel, table=True):
    __tablename__ = "activitylog" # Explicit table name to match potential existing schema or Alembic preferences if needed, though default snake_case is standard. Let's stick to default unless specified. Using class name default is fine for SQLModel.
    
    id: uuid.UUID = Field(default_factory=uuid.uuid4, primary_key=True)

    start_time: datetime = Field(default_factory=get_utc_now, index=True)
    end_time: Optional[datetime] = Field(default=None)
    description: Optional[str] = None

    user_id: uuid.UUID = Field(foreign_key="user.id", index=True)
    user: Optional["User"] = Relationship(back_populates="activities")

    category_id: Optional[uuid.UUID] = Field(foreign_key="category.id", default=None, index=True)
    category: Optional["Category"] = Relationship(back_populates="activities")
