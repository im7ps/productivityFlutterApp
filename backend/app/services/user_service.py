from fastapi import HTTPException, status
from app.core.security import get_password_hash
from app.models.user import User
from app.repositories.user_repo import UserRepository
from app.schemas.user import UserCreate


class UserService:
    def __init__(self, user_repo: UserRepository):
        self.user_repo = user_repo

    async def create_user(self, user_create: UserCreate) -> User:
        """
        Main service to create a user, handling business logic for validation and creation.
        """
        # 1. Check if username or email already exists
        existing_user = await self.user_repo.get_by_username(user_create.username)
        if existing_user:
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail="Username already registered",
            )
            
        existing_email = await self.user_repo.get_by_email(user_create.email)
        if existing_email:
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail="Email already registered",
            )

        # 2. Hash the password
        hashed_password = get_password_hash(user_create.password)

        # 3. Create the User model instance
        user_model = User(
            username=user_create.username,
            email=user_create.email,
            hashed_password=hashed_password,
        )

        # 4. Pass the prepared model to the repository
        return await self.user_repo.create(user_model)

    async def get_user_by_username(self, username: str) -> User | None:
        """
        Service to retrieve a user by username.
        """
        return await self.user_repo.get_by_username(username)
