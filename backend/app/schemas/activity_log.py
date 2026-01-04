from sqlmodel import SQLModel
import uuid
from datetime import datetime
from typing import Optional

# --- Schemi ActivityLog ---

class ActivityLogCreate(SQLModel):
    start_time: datetime
    end_time: Optional[datetime] = None
    description: Optional[str] = None
    category_id: Optional[uuid.UUID] = None

class ActivityLogUpdate(SQLModel):
    start_time: Optional[datetime] = None
    end_time: Optional[datetime] = None
    description: Optional[str] = None
    category_id: Optional[uuid.UUID] = None

class ActivityLogRead(SQLModel):
    id: uuid.UUID
    start_time: datetime
    end_time: Optional[datetime]
    description: Optional[str]
    category_id: Optional[uuid.UUID]
