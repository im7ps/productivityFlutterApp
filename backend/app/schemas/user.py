from sqlmodel import SQLModel
import uuid
from datetime import datetime
from typing import Optional

# Schema per la REGISTRAZIONE (quello che invia Flutter)
class UserCreate(SQLModel):
    username: str
    email: str
    password: str

# Schema per l'AGGIORNAMENTO (campi opzionali)
class UserUpdate(SQLModel):
    username: Optional[str] = None
    email: Optional[str] = None
    password: Optional[str] = None

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
