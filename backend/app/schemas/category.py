from sqlmodel import SQLModel
import uuid
from typing import Optional
from pydantic import field_validator

from .base import TunableBaseModel
from .validators import validate_xss_basic

# --- Schemi Categoria ---

class CategoryCreate(TunableBaseModel):
    name: str
    icon: str = "circle"
    color: str = "blue"

    @field_validator("name")
    def validate_name(cls, v: str) -> str:
        if not (3 <= len(v) <= 50):
            raise ValueError("Name must be between 3 and 50 characters")
        return validate_xss_basic(v)

class CategoryUpdate(TunableBaseModel):
    name: Optional[str] = None
    icon: Optional[str] = None
    color: Optional[str] = None

    @field_validator("name")
    def validate_name(cls, v: Optional[str]) -> Optional[str]:
        if v is None:
            return v
        if not (3 <= len(v) <= 50):
            raise ValueError("Name must be between 3 and 50 characters")
        return validate_xss_basic(v)

class CategoryRead(SQLModel):
    id: uuid.UUID
    name: str
    icon: str
    color: str