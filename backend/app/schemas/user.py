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
    
    # Onboarding & Stats Update
    is_onboarding_completed: Optional[bool] = None
    stat_strength: Optional[int] = None
    stat_endurance: Optional[int] = None
    stat_intelligence: Optional[int] = None
    stat_focus: Optional[int] = None

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

# --- INTERNAL DTOs (Data Transfer Objects) ---
# DTO INTERNO per l'aggiornamento sul DB (Service -> Repo).
# PERCHÉ ESISTE?
# 1. Disaccoppiamento: Separa il contratto API (UserUpdate, che riceve 'password' in chiaro)
#    dalla rappresentazione interna del DB (che richiede 'hashed_password').
# 2. Sicurezza: Assicura che al Repository arrivi sempre e solo l'hash, mai la password in chiaro.
# 3. Type Safety: Evita l'uso di dizionari generici (dict), permettendo validazione statica dei campi.
class UserUpdateDB(TunableBaseModel):
    username: Optional[str] = None
    email: Optional[EmailStr] = None
    hashed_password: Optional[str] = None
    
    # Onboarding & Stats Update
    is_onboarding_completed: Optional[bool] = None
    stat_strength: Optional[int] = None
    stat_endurance: Optional[int] = None
    stat_intelligence: Optional[int] = None
    stat_focus: Optional[int] = None

# Schema per la RISPOSTA
class UserPublic(SQLModel):
    id: uuid.UUID
    username: str
    email: str
    created_at: datetime
    
    # Onboarding & Stats
    is_onboarding_completed: bool
    daily_reached_goal: int
    stat_strength: int
    stat_endurance: int
    stat_intelligence: int
    stat_focus: int

# Schema per il TOKEN
class Token(SQLModel):
    access_token: str
    token_type: str = "bearer"
