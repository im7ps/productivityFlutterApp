from app.core.exceptions import InvalidCredentials
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
        import asyncio
        
        user = await self.user_service.get_user_by_username(username)
        if not user:
            raise InvalidCredentials("Incorrect username or password")
            
        loop = asyncio.get_running_loop()
        is_valid = await loop.run_in_executor(None, verify_password, password, user.hashed_password)
        
        if not is_valid:
            raise InvalidCredentials("Incorrect username or password")
        return user

    def create_jwt(self, user: UserPublic) -> dict:
        """
        Create a JWT token for a user.
        Uses the user's ID (immutable) as the subject, not the username.
        """
        access_token = create_access_token(data={"sub": str(user.id)})
        return {"access_token": access_token, "token_type": "bearer"}
