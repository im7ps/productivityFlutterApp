from typing import Annotated
from fastapi import Depends, HTTPException, status
from fastapi.security import OAuth2PasswordBearer
from sqlalchemy.ext.asyncio import AsyncSession

from app.core.security import decode_access_token, InvalidTokenError
from app.database.session import get_session
from app.models.user import User
from app.repositories.user_repo import UserRepository
from app.services.user_service import UserService
from app.services.auth_service import AuthService

oauth2_scheme = OAuth2PasswordBearer(tokenUrl="/api/v1/auth/login")

# --- Dependency Injection Provider Functions ---

def get_user_repo(session: Annotated[AsyncSession, Depends(get_session)]) -> UserRepository:
    return UserRepository(session)

def get_user_service(repo: Annotated[UserRepository, Depends(get_user_repo)]) -> UserService:
    return UserService(repo)

def get_auth_service(user_service: Annotated[UserService, Depends(get_user_service)]) -> AuthService:
    return AuthService(user_service)


# --- Type Aliases for Dependencies ---

TokenDep = Annotated[str, Depends(oauth2_scheme)]
UserServiceDep = Annotated[UserService, Depends(get_user_service)]
AuthServiceDep = Annotated[AuthService, Depends(get_auth_service)]

# --- Dependency for Getting Current User ---

async def get_current_user(
    token: TokenDep,
    user_service: UserServiceDep
) -> User:
    """
    Dependency to get the current authenticated user from a JWT token.
    """
    try:
        payload = decode_access_token(token)
        username: str | None = payload.get("sub")
        if username is None:
            raise InvalidTokenError("Subject not found in token")
    except InvalidTokenError as e:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail=str(e),
            headers={"WWW-Authenticate": "Bearer"},
        )

    user = await user_service.get_user_by_username(username)
    if user is None:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="User not found",
            headers={"WWW-Authenticate": "Bearer"},
        )
    return user

CurrentUser = Annotated[User, Depends(get_current_user)]
