import uuid
from sqlmodel import SQLModel, Field, Relationship
from typing import Optional, TYPE_CHECKING
from datetime import date

if TYPE_CHECKING:
    from app.models.user import User

# --- LOG GIORNALIERO ---
class DailyLog(SQLModel, table=True):
    __tablename__ = "dailylog" # Explicit naming often helps avoid issues, but SQLModel defaults are usually fine.
    
    id: uuid.UUID = Field(default_factory=uuid.uuid4, primary_key=True)
    day: date = Field(default_factory=date.today, index=True)

    sleep_hours: float = Field(default=0.0)
    sleep_quality: int = Field(default=5)
    mood_score: int = Field(default=5)
    diet_quality: int = Field(default=5)
    exercise_minutes: int = Field(default=0)
    note: Optional[str] = None

    user_id: uuid.UUID = Field(foreign_key="user.id", index=True)
    user: Optional["User"] = Relationship(back_populates="daily_logs")
