from sqlmodel import SQLModel
import uuid
from datetime import datetime
from typing import Optional

from sqlmodel import SQLModel
import uuid
from datetime import datetime
from typing import Optional
import re
from pydantic import field_validator, ConfigDict


from .base import TunableBaseModel
import uuid
from datetime import datetime
from typing import Optional
import re
from pydantic import field_validator, EmailStr

# Schema per la REGISTRAZIONE (quello che invia Flutter)
class UserCreate(TunableBaseModel):
    username: str
    email: EmailStr
    password: str

    @field_validator("password")
    def validate_password(cls, v: str) -> str:
        if len(v) < 8:
            raise ValueError("Password must be at least 8 characters long")
        if not re.search(r"[A-Z]", v):
            raise ValueError("Password must contain at least one uppercase letter")
        if not re.search(r"[a-z]", v):
            raise ValueError("Password must contain at least one lowercase letter")
        if not re.search(r"\d", v):
            raise ValueError("Password must contain at least one digit")
        if not re.search(r"[!@#$%^&*(),.?\":{}|<>]", v):
            raise ValueError("Password must contain at least one special character")
        return v

    @field_validator("username")
    def validate_username(cls, v: str) -> str:
        if not (3 <= len(v) <= 20):
            raise ValueError("Username must be between 3 and 20 characters")
        if not v.isalnum():
            raise ValueError("Username must be alphanumeric")
        return v

    @field_validator("email", mode='before')
    def validate_email(cls, v: str) -> str:
        return v.lower()


# Schema per l'AGGIORNAMENTO (campi opzionali)
class UserUpdate(TunableBaseModel):
    username: Optional[str] = None
    email: Optional[EmailStr] = None
    password: Optional[str] = None

    @field_validator("password")
    def validate_password(cls, v: str) -> str:
        if v is None:
            return v
        if len(v) < 8:
            raise ValueError("Password must be at least 8 characters long")
        if not re.search(r"[A-Z]", v):
            raise ValueError("Password must contain at least one uppercase letter")
        if not re.search(r"[a-z]", v):
            raise ValueError("Password must contain at least one lowercase letter")
        if not re.search(r"\d", v):
            raise ValueError("Password must contain at least one digit")
        if not re.search(r"[!@#$%^&*(),.?\":{}|<>]", v):
            raise ValueError("Password must contain at least one special character")
        return v

    @field_validator("username")
    def validate_username(cls, v: str) -> str:
        if v is None:
            return v
        if not (3 <= len(v) <= 20):
            raise ValueError("Username must be between 3 and 20 characters")
        if not v.isalnum():
            raise ValueError("Username must be alphanumeric")
        return v

    @field_validator("email", mode='before')
    def validate_email(cls, v: str) -> str:
        if v is None:
            return v
        return v.lower()

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
