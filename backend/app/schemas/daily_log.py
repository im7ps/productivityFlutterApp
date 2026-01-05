from sqlmodel import SQLModel
import uuid
from datetime import date
from typing import Optional
from pydantic import field_validator, ConfigDict

from .base import TunableBaseModel
import uuid
from datetime import date, datetime
from typing import Optional
from pydantic import field_validator

# --- Schemi DailyLog ---

class DailyLogCreate(TunableBaseModel):
    day: date
    sleep_hours: float = 0.0
    sleep_quality: int = 5
    mood_score: int = 5
    diet_quality: int = 5
    exercise_minutes: int = 0
    note: Optional[str] = None

    @field_validator("day")
    def validate_day(cls, v: date) -> date:
        if v > date.today():
            raise ValueError("Date cannot be in the future")
        return v

    @field_validator("sleep_quality", "mood_score", "diet_quality")
    def validate_quality_scores(cls, v: int) -> int:
        if not (1 <= v <= 5):
            raise ValueError("Score must be between 1 and 5")
        return v

    @field_validator("sleep_hours")
    def validate_sleep_hours(cls, v: float) -> float:
        if not (0 <= v <= 24):
            raise ValueError("Sleep hours must be between 0 and 24")
        return v
    
    @field_validator("exercise_minutes")
    def validate_non_negative(cls, v: float) -> float:
        if v < 0:
            raise ValueError("Value cannot be negative")
        return v


class DailyLogUpdate(TunableBaseModel):
    sleep_hours: Optional[float] = None
    sleep_quality: Optional[int] = None
    mood_score: Optional[int] = None
    diet_quality: Optional[int] = None
    exercise_minutes: Optional[int] = None
    note: Optional[str] = None

    @field_validator("sleep_quality", "mood_score", "diet_quality")
    def validate_quality_scores(cls, v: int) -> int:
        if v is None:
            return v
        if not (1 <= v <= 5):
            raise ValueError("Score must be between 1 and 5")
        return v

    @field_validator("sleep_hours")
    def validate_sleep_hours(cls, v: float) -> float:
        if v is None:
            return v
        if not (0 <= v <= 24):
            raise ValueError("Sleep hours must be between 0 and 24")
        return v

    @field_validator("exercise_minutes")
    def validate_non_negative(cls, v: float) -> float:
        if v is None:
            return v
        if v < 0:
            raise ValueError("Value cannot be negative")
        return v

class DailyLogRead(SQLModel):
    id: uuid.UUID
    day: date
    sleep_hours: float
    sleep_quality: int
    mood_score: int
    diet_quality: int
    exercise_minutes: int
    note: Optional[str]
