from typing import Annotated
from fastapi import APIRouter, Depends, status
from fastapi.security import OAuth2PasswordRequestForm

from app.schemas.user import UserCreate, UserPublic, Token
from app.api.v1.deps import CurrentUser, UserServiceDep, AuthServiceDep

router = APIRouter()

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
    auth_service: AuthServiceDep
):
    """
    Handles user login, verification, and token generation.
    """
    user = await auth_service.authenticate_user(form_data.username, form_data.password)
    return auth_service.create_jwt(user)

@router.get("/me", response_model=UserPublic)
async def read_current_user(current_user: CurrentUser):
    return current_user

