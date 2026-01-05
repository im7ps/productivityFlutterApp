from fastapi import APIRouter
from app.schemas.user import UserPublic
from app.api.v1.routers.auth import CurrentUser

router = APIRouter()


@router.get("/me", response_model=UserPublic)
async def read_users_me(current_user: CurrentUser):
    """
    Get the public information of the currently authenticated user.
    """
    return current_user
