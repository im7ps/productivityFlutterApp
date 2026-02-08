from fastapi import APIRouter
from app.api.v1.routers import auth, users, dimensions, daily_logs, actions

api_router = APIRouter()

api_router.include_router(auth.router, prefix="/auth", tags=["auth"])
api_router.include_router(users.router, prefix="/users", tags=["users"])
api_router.include_router(dimensions.router, prefix="/dimensions", tags=["dimensions"])
api_router.include_router(actions.router, prefix="/actions", tags=["actions"])
api_router.include_router(daily_logs.router, prefix="/daily-logs", tags=["daily-logs"])
