from typing import Annotated
import uuid
from fastapi import Depends, HTTPException, status
from fastapi.security import OAuth2PasswordBearer
from sqlalchemy.ext.asyncio import AsyncSession

from app.core.security import decode_access_token
from app.core.exceptions import InvalidCredentials, AccessTokenExpired, InvalidToken
from app.database.session import get_session
from app.models.user import User
from app.repositories.user_repo import UserRepository
from app.services.user_service import UserService
from app.services.auth_service import AuthService

oauth2_scheme = OAuth2PasswordBearer(tokenUrl="/api/v1/auth/login")

# --- Dependency Injection Provider Functions ---

def get_user_repo(session: Annotated[AsyncSession, Depends(get_session)]) -> UserRepository:
    return UserRepository(session)

def get_user_service(
    session: Annotated[AsyncSession, Depends(get_session)],
    repo: Annotated[UserRepository, Depends(get_user_repo)]
) -> UserService:
    return UserService(session=session, user_repo=repo)

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
    Decodes the token using domain logic (security.py) and handles domain exceptions.
    """
    try:
        payload = decode_access_token(token)
        user_id_str: str | None = payload.get("sub")
        if user_id_str is None:
            raise InvalidToken("Subject not found in token")
            
    except AccessTokenExpired:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Token expired",
            headers={"WWW-Authenticate": "Bearer"},
        )
    except (InvalidToken, InvalidCredentials):
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Could not validate credentials",
            headers={"WWW-Authenticate": "Bearer"},
        )

    try:
        user_id = uuid.UUID(user_id_str)
    except ValueError:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Invalid user ID format in token",
            headers={"WWW-Authenticate": "Bearer"},
        )

    user = await user_service.get_user_by_id(user_id)
    if user is None:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="User not found",
            headers={"WWW-Authenticate": "Bearer"},
        )
    return user

CurrentUser = Annotated[User, Depends(get_current_user)]
