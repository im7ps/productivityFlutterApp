from sqlalchemy.ext.asyncio import AsyncSession
from sqlmodel import select

from app.models.user import User
from app.repositories.base_repo import BaseRepository
from app.schemas.user import UserCreate, UserUpdate


class UserRepository(BaseRepository[User, UserCreate, UserUpdate]):
    def __init__(self, session: AsyncSession):
        super().__init__(User, session)

    async def create(self, user_model: User) -> User:
        """
        Creates a user record in the database from a User model.
        Password must already be hashed.
        """
        self.session.add(user_model)
        await self.session.commit()
        await self.session.refresh(user_model)
        return user_model

    async def get_by_username(self, username: str) -> User | None:
        """
        Retrieves a user by their username, case-insensitively.
        """
        statement = select(self.model).where(self.model.username.ilike(username))
        result = await self.session.execute(statement)
        return result.scalars().first()
    
    async def get_by_email(self, email: str) -> User | None:
        """
        Retrieves a user by their email, case-insensitively.
        """
        statement = select(self.model).where(self.model.email.ilike(email))
        result = await self.session.execute(statement)
        return result.scalars().first()

