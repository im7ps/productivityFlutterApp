from typing import Annotated
from fastapi import APIRouter, Depends, HTTPException, status
from fastapi.security import OAuth2PasswordRequestForm, OAuth2PasswordBearer
from sqlalchemy.ext.asyncio import AsyncSession
from jose import JWTError, jwt

from app.database.session import get_session
from app.core.security import verify_password, create_access_token, SECRET_KEY, ALGORITHM
from app.schemas.user import UserCreate, UserPublic, Token
from app.repositories.user_repo import UserRepository
from app.services.user_service import UserService
from app.models.user import User

router = APIRouter()
oauth2_scheme = OAuth2PasswordBearer(tokenUrl="/api/v1/auth/login")

# --- Dependency Injection ---

def get_user_repo(session: Annotated[AsyncSession, Depends(get_session)]) -> UserRepository:
    return UserRepository(session)

def get_user_service(repo: Annotated[UserRepository, Depends(get_user_repo)]) -> UserService:
    return UserService(repo)

# Type alias for dependency injection
UserServiceDep = Annotated[UserService, Depends(get_user_service)]
TokenDep = Annotated[str, Depends(oauth2_scheme)]

# --- Router Endpoints ---

@router.post("/register", response_model=UserPublic, status_code=status.HTTP_201_CREATED)
async def signup(
    user_data: UserCreate, 
    user_service: UserServiceDep
):
    """
    Handles user registration.
    Delegates all business logic to the user service.
    """
    new_user = await user_service.create_user(user_data)
    return new_user


@router.post("/login", response_model=Token)
async def login(
    form_data: Annotated[OAuth2PasswordRequestForm, Depends()],
    user_service: UserServiceDep
):
    """
    Handles user login, verification, and token generation.
    """
    # 1. Find the user via the service
    user = await user_service.get_user_by_username(form_data.username)

    # 2. Verify user and password
    if not user or not verify_password(form_data.password, user.hashed_password):
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Incorrect username or password",
            headers={"WWW-Authenticate": "Bearer"},
        )

    # 3. Generate JWT token
    access_token = create_access_token(data={"sub": user.username})
    return {"access_token": access_token, "token_type": "bearer"}


async def get_current_user(
    token: TokenDep, 
    user_service: UserServiceDep
) -> User:
    """
    Dependency to get the current authenticated user from a JWT token.
    """
    credentials_exception = HTTPException(
        status_code=status.HTTP_401_UNAUTHORIZED,
        detail="Could not validate credentials",
        headers={"WWW-Authenticate": "Bearer"},
    )
    try:
        payload = jwt.decode(token, SECRET_KEY, algorithms=[ALGORITHM])
        username: str | None = payload.get("sub")
        if username is None:
            raise credentials_exception
    except JWTError:
        raise credentials_exception

    user = await user_service.get_user_by_username(username)
    if user is None:
        raise credentials_exception
    return user

# Type alias for the current user dependency
CurrentUser = Annotated[User, Depends(get_current_user)]

