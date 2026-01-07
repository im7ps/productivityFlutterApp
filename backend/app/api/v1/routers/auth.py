from typing import Annotated
from fastapi import APIRouter, Depends, status, Request
from fastapi.security import OAuth2PasswordRequestForm

from app.schemas.user import UserCreate, UserPublic, Token
from app.api.v1.deps import CurrentUser, UserServiceDep, AuthServiceDep
from app.core.rate_limit import limiter

router = APIRouter()

# --- Router Endpoints ---

@router.post("/register", response_model=UserPublic, status_code=status.HTTP_201_CREATED)
@limiter.limit("20/minute")
async def signup(
    request: Request,
    user_data: UserCreate,
    user_service: UserServiceDep
):
    """
    Handles user registration.
    Delegates all business logic to the user service.
    Rate Limit: 20 requests per minute.
    """
    new_user = await user_service.create_user(user_data)
    return new_user


@router.post("/login", response_model=Token)
@limiter.limit("5/minute")
async def login(
    request: Request,
    form_data: Annotated[OAuth2PasswordRequestForm, Depends()],
    auth_service: AuthServiceDep
):
    """
    Handles user login, verification, and token generation.
    Rate Limit: 5 requests per minute.
    """
    user = await auth_service.authenticate_user(form_data.username, form_data.password)
    return auth_service.create_jwt(user)

@router.get("/me", response_model=UserPublic)
async def read_current_user(current_user: CurrentUser):
    return current_user

