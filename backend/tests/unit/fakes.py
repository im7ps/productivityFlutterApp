import uuid
from datetime import datetime
from typing import Optional
from app.models.user import User

class FakeUserRepository:
    """
    A fake, in-memory repository that mimics the interface of UserRepository
    for unit testing services in isolation.
    """
    def __init__(self):
        self.users: list[User] = []

    async def create(self, user_model: User) -> User:
        user_model.id = user_model.id or uuid.uuid4()
        user_model.created_at = user_model.created_at or datetime.utcnow()
        self.users.append(user_model)
        return user_model

    async def get_by_username(self, username: str) -> Optional[User]:
        return next((u for u in self.users if u.username == username), None)
    
    async def get_by_email(self, email: str) -> Optional[User]:
        return next((u for u in self.users if u.email == email), None)
