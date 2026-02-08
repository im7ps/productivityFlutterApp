from sqlmodel import SQLModel
from typing import Optional

# --- Schemi Dimension ---

class DimensionRead(SQLModel):
    id: str # Slug
    name: str # Display Name
    description: Optional[str] = None
