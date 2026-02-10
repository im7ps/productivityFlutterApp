from sqlmodel import SQLModel
import uuid
from typing import Optional
from datetime import datetime
from pydantic import field_validator

from .base import TunableBaseModel
from .dimension import DimensionRead
from .validators import validate_xss_basic

# --- Schemi Action ---

class ActionBase(TunableBaseModel):
    description: Optional[str] = None
    category: str = "Dovere"
    difficulty: int = 3
    status: str = "COMPLETED"
    start_time: Optional[datetime] = None
    end_time: Optional[datetime] = None
    dimension_id: Optional[str] = None # Now String
    fulfillment_score: int = 3

    @field_validator("description")
    def validate_desc(cls, v: Optional[str]) -> Optional[str]:
        if v is None:
            return v
        return validate_xss_basic(v)
        
    @field_validator("fulfillment_score")
    def validate_score(cls, v: int) -> int:
        if not (1 <= v <= 5):
            raise ValueError("Fulfillment score must be between 1 and 5")
        return v

class ActionCreate(ActionBase):
    dimension_id: str # Required (Slug)
    fulfillment_score: int # Required

class ActionUpdate(ActionBase):
    pass

class ActionRead(ActionBase):
    id: uuid.UUID
    user_id: uuid.UUID
    created_at: Optional[datetime] = None
    dimension: Optional[DimensionRead] = None
