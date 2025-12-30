from sqlmodel import SQLModel, Field
from typing import Optional
from datetime import datetime, timezone  # 1. Added timezone here
import uuid

# Database Table Model
class User(SQLModel, table=True):
    id: uuid.UUID = Field(default_factory=uuid.uuid4, primary_key=True, index=True)
    username: str = Field(unique=True, index=True)
    email: str = Field(unique=True)
    hashed_password: str
    is_active: bool = Field(default=True)
    
    # 2. Updated default_factory to use a lambda with timezone awareness
    created_at: datetime = Field(
        default_factory=lambda: datetime.now(timezone.utc)
    )

# Schema per la REGISTRAZIONE (quello che invia Flutter)
class UserCreate(SQLModel):
    username: str
    email: str
    password: str = Field(max_length=72)

# Schema per la RISPOSTA (quello che torna a Flutter, senza password!)
class UserPublic(SQLModel):
    id: uuid.UUID
    username: str
    email: str
    created_at: datetime


# Schema per la risposta del Login
class Token(SQLModel):
    access_token: str
    token_type: str = "bearer"


