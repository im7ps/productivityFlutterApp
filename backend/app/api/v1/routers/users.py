from fastapi import APIRouter, Depends
from sqlalchemy.ext.asyncio import AsyncSession

from app.database.session import get_session
from app.schemas.user import UserPublic
from app.models.user import User
from app.api.v1.routers.auth import get_current_user

router = APIRouter()

@router.get("/me", response_model=UserPublic)
async def read_users_me(current_user: User = Depends(get_current_user)):
    return current_user
