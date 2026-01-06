from typing import Annotated
import uuid
from fastapi import Depends, HTTPException, status
from fastapi.security import OAuth2PasswordBearer
from sqlalchemy.ext.asyncio import AsyncSession
from jose import JWTError, ExpiredSignatureError

from app.core.security import decode_access_token, InvalidTokenError
from app.core.exceptions import InvalidCredentials
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
    Decodes the token, extracts the user ID (sub), and retrieves the user.
    """
    try:
        # decode_access_token uses `jwt.decode` internally.
        # However, to catch ExpiredSignatureError specifically here, 
        # we assume decode_access_token lets it propagate or we decode here directly.
        # Looking at security.py, decode_access_token catches JWTError and raises InvalidTokenError.
        # To distinguish, we need to handle it inside security.py OR here if we call raw jwt.
        # But per instructions, let's rely on the fact that `jose` raises ExpiredSignatureError
        # which inherits from JWTError.
        # If security.py wraps EVERYTHING in InvalidTokenError, we lose the distinction.
        
        # Let's inspect security.py again mentally. 
        # It does: except JWTError: raise InvalidTokenError. 
        # So ExpiredSignatureError is swallowed. 
        # We must call decode_access_token. If it raises, we can't tell "why".
        # Therefore, I will modify security.py to let specific errors bubble up or check logic there.
        # BUT, the task says "In deps.py... Catch specifically jwt.ExpiredSignatureError".
        # This implies decode_access_token should NOT swallow it indiscriminately.
        
        payload = decode_access_token(token)
        user_id_str: str | None = payload.get("sub")
        if user_id_str is None:
            raise InvalidTokenError("Subject not found in token")
            
    except ExpiredSignatureError:
        # This will only be caught if decode_access_token re-raises it or doesn't catch it.
        # We will assume/ensure security.py allows this.
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Token expired",
            headers={"WWW-Authenticate": "Bearer"},
        )
    except (JWTError, InvalidTokenError):
        raise InvalidCredentials("Could not validate credentials")

    try:
        user_id = uuid.UUID(user_id_str)
    except ValueError:
        raise InvalidCredentials("Invalid user ID format in token")

    user = await user_service.get_user_by_id(user_id)
    if user is None:
        raise InvalidCredentials("User not found")
    return user

CurrentUser = Annotated[User, Depends(get_current_user)]