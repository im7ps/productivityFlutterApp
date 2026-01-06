from sqlmodel import SQLModel
import uuid
from datetime import datetime
from typing import Optional
from pydantic import model_validator

from .base import TunableBaseModel

# --- Schemi ActivityLog ---

class ActivityLogCreate(TunableBaseModel):
    start_time: datetime
    end_time: Optional[datetime] = None
    description: Optional[str] = None
    category_id: Optional[uuid.UUID] = None

    @model_validator(mode='after')
    def validate_end_time(self) -> 'ActivityLogCreate':
        if self.end_time and self.end_time <= self.start_time:
            raise ValueError("end_time must be after start_time")
        return self

class ActivityLogUpdate(TunableBaseModel):
    start_time: Optional[datetime] = None
    end_time: Optional[datetime] = None
    description: Optional[str] = None
    category_id: Optional[uuid.UUID] = None

    # Nota: La validazione end_time > start_time è delegata al Service Layer
    # perché in un update parziale potremmo non avere entrambi i valori qui.

class ActivityLogRead(SQLModel):
    id: uuid.UUID
    start_time: datetime
    end_time: Optional[datetime]
    description: Optional[str]
    category_id: Optional[uuid.UUID]