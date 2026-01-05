from sqlmodel import SQLModel
import uuid
from typing import Optional
from pydantic import field_validator, ConfigDict

from .base import TunableBaseModel
import uuid
from typing import Optional
from pydantic import field_validator

# --- Schemi Categoria ---

# Schema per CREARE una categoria (Input)
class CategoryCreate(TunableBaseModel):
    name: str
    icon: str = "circle"
    color: str = "blue"

    @field_validator("name")
    def validate_name(cls, v: str) -> str:
        if not (3 <= len(v) <= 50):
            raise ValueError("Name must be between 3 and 50 characters")
        if "<" in v or ">" in v:
            raise ValueError("Name cannot contain '<' or '>' characters")
        return v

# Schema per AGGIORNARE una categoria
class CategoryUpdate(TunableBaseModel):
    name: Optional[str] = None
    icon: Optional[str] = None
    color: Optional[str] = None

    @field_validator("name")
    def validate_name(cls, v: str) -> str:
        if v is None:
            return v
        if not (3 <= len(v) <= 50):
            raise ValueError("Name must be between 3 and 50 characters")
        if "<" in v or ">" in v:
            raise ValueError("Name cannot contain '<' or '>' characters")
        return v

# Schema per LEGGERE una categoria (Output)
class CategoryRead(SQLModel):
    id: uuid.UUID
    name: str
    icon: str
    color: str
