from sqlmodel import SQLModel
import uuid
from datetime import datetime
from typing import Optional
from pydantic import ConfigDict

from .base import TunableBaseModel
import uuid
from datetime import datetime
from typing import Optional
from pydantic import model_validator

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

    @model_validator(mode='after')
    def validate_end_time(self) -> 'ActivityLogUpdate':
        # This validator needs to handle both start_time and end_time being optional
        # and potentially only one of them being updated.
        # If end_time is provided, we must ensure it's valid.
        if self.end_time:
            # If start_time is also being updated, comparison is straightforward.
            if self.start_time and self.end_time <= self.start_time:
                raise ValueError("end_time must be after start_time")
            # If start_time is NOT being updated, we'd need the original object's start_time.
            # This requires a more complex validation at the service/API level,
            # as the Pydantic model itself doesn't have access to the existing DB state.
            # For now, we validate if both are present in the update payload.
        return self

class ActivityLogRead(SQLModel):
    id: uuid.UUID
    start_time: datetime
    end_time: Optional[datetime]
    description: Optional[str]
    category_id: Optional[uuid.UUID]
