from sqlmodel import SQLModel
import uuid
from typing import Optional

# --- Schemi Categoria ---

# Schema per CREARE una categoria (Input)
class CategoryCreate(SQLModel):
    name: str
    icon: str = "circle"
    color: str = "blue"

# Schema per AGGIORNARE una categoria
class CategoryUpdate(SQLModel):
    name: Optional[str] = None
    icon: Optional[str] = None
    color: Optional[str] = None

# Schema per LEGGERE una categoria (Output)
class CategoryRead(SQLModel):
    id: uuid.UUID
    name: str
    icon: str
    color: str
