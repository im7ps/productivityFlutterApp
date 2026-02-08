from sqlmodel import SQLModel, Field, Relationship
from typing import Optional, List, TYPE_CHECKING

if TYPE_CHECKING:
    from app.models.action import Action

# --- DIMENSIONI (ex Categorie) ---
class Dimension(SQLModel, table=True):
    # ID is now the Slug (e.g., 'energy', 'clarity')
    id: str = Field(primary_key=True, index=True) 
    name: str = Field(unique=True, index=True) # Display Name (e.g., "Energia")
    description: Optional[str] = None
    
    actions: List["Action"] = Relationship(back_populates="dimension")
