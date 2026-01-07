from sqlalchemy.exc import IntegrityError
import uuid

from app.core.exceptions import EntityAlreadyExists
from app.core.security import get_password_hash
from app.models.user import User
from app.repositories.user_repo import UserRepository
from app.schemas.user import UserCreate


from sqlalchemy.ext.asyncio import AsyncSession

class UserService:
    def __init__(self, session: AsyncSession, user_repo: UserRepository):
        self.session = session
        self.user_repo = user_repo

    async def create_user(self, user_create: UserCreate) -> User:
        """
        Main service to create a user, handling business logic for validation and creation.
        Includes a race-condition check using DB integrity constraints.
        """
        # 1. Pre-check (Optimization to avoid DB exceptions for common cases)
        existing_user = await self.user_repo.get_by_username(user_create.username)
        if existing_user:
            raise EntityAlreadyExists("Username already registered")
            
        existing_email = await self.user_repo.get_by_email(user_create.email)
        if existing_email:
            raise EntityAlreadyExists("Email already registered")

        # 2. Hash the password
        import asyncio
        loop = asyncio.get_running_loop()
        hashed_password = await loop.run_in_executor(None, get_password_hash, user_create.password)

        # 3. Create the User model instance
        user_model = User(
            username=user_create.username,
            email=user_create.email,
            hashed_password=hashed_password,
        )

        # 4. Pass the prepared model to the repository with race-condition handling
        try:
            created_user = await self.user_repo.create(user_model)
            await self.session.commit()
            return created_user
        except IntegrityError:
            await self.session.rollback()
            # This catches cases where a duplicate was inserted between the pre-check and the commit
            raise EntityAlreadyExists("User with this email or username already exists")
        except Exception:
            await self.session.rollback()
            raise

    async def get_user_by_username(self, username: str) -> User | None:
        """
        Service to retrieve a user by username.
        """
        return await self.user_repo.get_by_username(username)

    async def get_user_by_id(self, user_id: uuid.UUID) -> User | None:
        """
        Service to retrieve a user by ID.
        """
        # Assumes the repository has a generic 'get' method accepting an ID
        return await self.user_repo.get(user_id)