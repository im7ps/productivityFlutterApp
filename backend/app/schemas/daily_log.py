from sqlmodel import SQLModel
import uuid
from datetime import date
from typing import Optional
from pydantic import field_validator

from .base import TunableBaseModel
from .validators import validate_score_range, validate_non_negative

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
    def validate_scores(cls, v: int) -> int:
        return validate_score_range(v)

    @field_validator("sleep_hours")
    def validate_sleep_hours(cls, v: float) -> float:
        if not (0 <= v <= 24):
            raise ValueError("Sleep hours must be between 0 and 24")
        return validate_non_negative(v)
    
    @field_validator("exercise_minutes")
    def validate_minutes(cls, v: int) -> int:
        return int(validate_non_negative(float(v)))


class DailyLogUpdate(TunableBaseModel):
    sleep_hours: Optional[float] = None
    sleep_quality: Optional[int] = None
    mood_score: Optional[int] = None
    diet_quality: Optional[int] = None
    exercise_minutes: Optional[int] = None
    note: Optional[str] = None

    @field_validator("sleep_quality", "mood_score", "diet_quality")
    def validate_scores(cls, v: Optional[int]) -> Optional[int]:
        return validate_score_range(v)

    @field_validator("sleep_hours")
    def validate_sleep_hours(cls, v: Optional[float]) -> Optional[float]:
        if v is None:
            return v
        if not (0 <= v <= 24):
            raise ValueError("Sleep hours must be between 0 and 24")
        return validate_non_negative(v)

    @field_validator("exercise_minutes")
    def validate_minutes(cls, v: Optional[int]) -> Optional[int]:
        if v is None:
            return v
        return int(validate_non_negative(float(v)))

class DailyLogRead(SQLModel):
    id: uuid.UUID
    day: date
    sleep_hours: float
    sleep_quality: int
    mood_score: int
    diet_quality: int
    exercise_minutes: int
    note: Optional[str]
