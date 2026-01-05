from fastapi import HTTPException, status
from app.core.security import verify_password, create_access_token
from app.schemas.user import UserPublic
from app.services.user_service import UserService


class AuthService:
    def __init__(self, user_service: UserService):
        self.user_service = user_service

    async def authenticate_user(self, username: str, password: str) -> UserPublic:
        """
        Authenticate a user by username and password.
        """
        user = await self.user_service.get_user_by_username(username)
        if not user or not verify_password(password, user.hashed_password):
            raise HTTPException(
                status_code=status.HTTP_401_UNAUTHORIZED,
                detail="Incorrect username or password",
                headers={"WWW-Authenticate": "Bearer"},
            )
        return user

    def create_jwt(self, user: UserPublic) -> dict:
        """
        Create a JWT token for a user.
        """
        access_token = create_access_token(data={"sub": user.username})
        return {"access_token": access_token, "token_type": "bearer"}