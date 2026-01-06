from sqlmodel import SQLModel
import uuid
from datetime import datetime
from typing import Optional
from pydantic import field_validator, EmailStr

from .base import TunableBaseModel
from .validators import validate_password_strength, validate_username_format

# Schema per la REGISTRAZIONE
class UserCreate(TunableBaseModel):
    username: str
    email: EmailStr
    password: str

    @field_validator("password")
    def validate_password(cls, v: str) -> str:
        return validate_password_strength(v)

    @field_validator("username")
    def validate_username(cls, v: str) -> str:
        return validate_username_format(v)

    @field_validator("email", mode='before')
    def validate_email(cls, v: str) -> str:
        return v.lower()


# Schema per l'AGGIORNAMENTO
class UserUpdate(TunableBaseModel):
    username: Optional[str] = None
    email: Optional[EmailStr] = None
    password: Optional[str] = None

    @field_validator("password")
    def validate_password(cls, v: Optional[str]) -> Optional[str]:
        return validate_password_strength(v)

    @field_validator("username")
    def validate_username(cls, v: Optional[str]) -> Optional[str]:
        return validate_username_format(v)

    @field_validator("email", mode='before')
    def validate_email(cls, v: Optional[str]) -> Optional[str]:
        if v is None:
            return v
        return v.lower()

# Schema per la RISPOSTA
class UserPublic(SQLModel):
    id: uuid.UUID
    username: str
    email: str
    created_at: datetime

# Schema per il TOKEN
class Token(SQLModel):
    access_token: str
    token_type: str = "bearer"
