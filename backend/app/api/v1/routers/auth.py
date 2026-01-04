from fastapi import APIRouter, Depends, HTTPException, status
from fastapi.security import OAuth2PasswordRequestForm
from sqlalchemy.ext.asyncio import AsyncSession
from jose import JWTError, jwt
from fastapi.security import OAuth2PasswordBearer

from app.database.session import get_session
from app.core.security import verify_password, create_access_token
from app.schemas.user import UserCreate, UserPublic, Token
from app.repositories import UserRepository
from app.models import User
from app.core.security import SECRET_KEY, ALGORITHM

router = APIRouter()
oauth2_scheme = OAuth2PasswordBearer(tokenUrl="/api/v1/auth/login")

def get_user_repo(session: AsyncSession = Depends(get_session)) -> UserRepository:
    return UserRepository(session)

@router.post("/register", response_model=UserPublic, status_code=status.HTTP_201_CREATED)
async def signup(
    user_data: UserCreate, 
    repo: UserRepository = Depends(get_user_repo)
):
    # 1. Check if user exists
    existing_user = await repo.get_user_by_username(user_data.username)
    if existing_user:
        raise HTTPException(status_code=400, detail="Username or Email already registered")

    # 2. Create user
    new_user = await repo.create_user(user_data)
    return new_user


@router.post("/login", response_model=Token)
async def login(
    form_data: OAuth2PasswordRequestForm = Depends(),
    repo: UserRepository = Depends(get_user_repo)
):
    # 1. Find the user in the DB by username
    user = await repo.get_user_by_username(form_data.username)

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
    token: str = Depends(oauth2_scheme), 
    repo: UserRepository = Depends(get_user_repo)
) -> User:
    credentials_exception = HTTPException(
        status_code=status.HTTP_401_UNAUTHORIZED,
        detail="Could not validate credentials",
        headers={"WWW-Authenticate": "Bearer"},
    )
    try:
        payload = jwt.decode(token, SECRET_KEY, algorithms=[ALGORITHM])
        username: str = payload.get("sub")
        if username is None:
            raise credentials_exception
    except JWTError:
        raise credentials_exception

    user = await repo.get_user_by_username(username)
    if user is None:
        raise credentials_exception
    return user
