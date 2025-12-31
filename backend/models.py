import uuid
from sqlmodel import SQLModel, Field, Relationship
from typing import Optional, List
from datetime import datetime, date, timezone

# Utility function to get current UTC time
def get_utc_now():
    return datetime.now(timezone.utc)


# --- UTENTE ---
class User(SQLModel, table=True):
    id: uuid.UUID = Field(default_factory=uuid.uuid4, primary_key=True, index=True)
    username: str = Field(unique=True, index=True)
    email: str = Field(unique=True)
    hashed_password: str
    is_active: bool = Field(default=True)
    # Usa la funzione helper, non la lambda, per massima pulizia
    created_at: datetime = Field(default_factory=get_utc_now)

    activities: List["ActivityLog"] = Relationship(back_populates="user")
    daily_logs: List["DailyLog"] = Relationship(back_populates="user")
    categories: List["Category"] = Relationship(back_populates="user")

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


# --- CATEGORIE ---
class Category(SQLModel, table=True):
    id: uuid.UUID = Field(default_factory=uuid.uuid4, primary_key=True)
    name: str
    icon: str = Field(default="circle")
    color: str = Field(default="blue")
    
    user_id: uuid.UUID = Field(foreign_key="user.id")
    user: Optional[User] = Relationship(back_populates="categories")
    
    activities: List["ActivityLog"] = Relationship(back_populates="category")

# --- LOG ATTIVITÀ ---
class ActivityLog(SQLModel, table=True):
    id: uuid.UUID = Field(default_factory=uuid.uuid4, primary_key=True)
    
    start_time: datetime = Field(default_factory=get_utc_now)
    end_time: Optional[datetime] = Field(default=None)
    description: Optional[str] = None
    
    user_id: uuid.UUID = Field(foreign_key="user.id")
    user: Optional[User] = Relationship(back_populates="activities")
    
    category_id: Optional[uuid.UUID] = Field(foreign_key="category.id", default=None)
    category: Optional[Category] = Relationship(back_populates="activities")

# --- LOG GIORNALIERO ---
class DailyLog(SQLModel, table=True):
    id: uuid.UUID = Field(default_factory=uuid.uuid4, primary_key=True)
    day: date = Field(default_factory=date.today)
    
    sleep_hours: float = Field(default=0.0)
    sleep_quality: int = Field(default=5)
    mood_score: int = Field(default=5)
    diet_quality: int = Field(default=5)
    exercise_minutes: int = Field(default=0)
    note: Optional[str] = None

    user_id: uuid.UUID = Field(foreign_key="user.id")
    user: Optional[User] = Relationship(back_populates="daily_logs")


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

