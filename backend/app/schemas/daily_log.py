from sqlmodel import SQLModel
import uuid
from datetime import date
from typing import Optional

# --- Schemi DailyLog ---

class DailyLogCreate(SQLModel):
    day: date
    sleep_hours: float = 0.0
    sleep_quality: int = 5
    mood_score: int = 5
    diet_quality: int = 5
    exercise_minutes: int = 0
    note: Optional[str] = None

class DailyLogUpdate(SQLModel):
    sleep_hours: Optional[float] = None
    sleep_quality: Optional[int] = None
    mood_score: Optional[int] = None
    diet_quality: Optional[int] = None
    exercise_minutes: Optional[int] = None
    note: Optional[str] = None

class DailyLogRead(SQLModel):
    id: uuid.UUID
    day: date
    sleep_hours: float
    sleep_quality: int
    mood_score: int
    diet_quality: int
    exercise_minutes: int
    note: Optional[str]
