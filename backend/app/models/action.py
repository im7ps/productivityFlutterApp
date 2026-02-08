import uuid
from sqlmodel import SQLModel, Field, Relationship
from typing import Optional, TYPE_CHECKING
from datetime import datetime
from app.models.utils import get_utc_now

if TYPE_CHECKING:
    from app.models.user import User
    from app.models.dimension import Dimension

# --- ACTIONS (ex ActivityLog) ---
class Action(SQLModel, table=True):
    __tablename__ = "action" 
    
    id: uuid.UUID = Field(default_factory=uuid.uuid4, primary_key=True)

    start_time: datetime = Field(default_factory=get_utc_now, index=True)
    end_time: Optional[datetime] = Field(default=None)
    description: Optional[str] = None
    
    # Fulfillment Score (1-5)
    fulfillment_score: int = Field(default=3, ge=1, le=5)

    user_id: uuid.UUID = Field(foreign_key="user.id", index=True)
    user: Optional["User"] = Relationship(back_populates="actions")

    # Dimension FK is now a String (Slug)
    dimension_id: str = Field(foreign_key="dimension.id", index=True)
    dimension: Optional["Dimension"] = Relationship(back_populates="actions")
