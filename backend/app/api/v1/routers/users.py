from fastapi import APIRouter
from app.schemas.user import UserPublic, UserUpdate
from app.api.v1.deps import CurrentUser, UserServiceDep

router = APIRouter()


@router.get("/me", response_model=UserPublic)
async def read_users_me(current_user: CurrentUser):
    """
    Get the public information of the currently authenticated user.
    """
    return current_user

@router.patch("/me", response_model=UserPublic)
async def update_user_me(
    user_in: UserUpdate,
    current_user: CurrentUser,
    user_service: UserServiceDep
):
    """
    Update own profile.
    """
    updated_user = await user_service.update_user(current_user, user_in)
    return updated_user
