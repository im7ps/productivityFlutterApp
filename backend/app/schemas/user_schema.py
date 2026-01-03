from sqlmodel import SQLModel
import uuid
from datetime import datetime

# Schema per la REGISTRAZIONE (quello che invia Flutter)
class UserCreate(SQLModel):
    username: str
    email: str
    password: str

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

# Schema per CREARE una categoria (Input)
class CategoryCreate(SQLModel):
    name: str
    icon: str = "circle"
    color: str = "blue"

# Schema per LEGGERE una categoria (Output)
class CategoryRead(SQLModel):
    id: uuid.UUID
    name: str
    icon: str
    color: str
