from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.ext.asyncio import AsyncSession
import uuid
from typing import List

from app.database.session import get_session
from app.schemas.activity_log import ActivityLogCreate, ActivityLogRead, ActivityLogUpdate
from app.models import User
from app.api.v1.routers.auth import get_current_user
from app.repositories import ActivityLogRepository

router = APIRouter()

def get_activity_log_repo(session: AsyncSession = Depends(get_session)) -> ActivityLogRepository:
    return ActivityLogRepository(session)

@router.post("", response_model=ActivityLogRead)
async def create_activity_log(
    log_data: ActivityLogCreate,
    repo: ActivityLogRepository = Depends(get_activity_log_repo),
    current_user: User = Depends(get_current_user)
):
    return await repo.create(obj_in=log_data, user_id=current_user.id)

@router.get("", response_model=List[ActivityLogRead])
async def read_activity_logs(
    repo: ActivityLogRepository = Depends(get_activity_log_repo),
    current_user: User = Depends(get_current_user)
):
    return await repo.get_all_by_user(user_id=current_user.id)

@router.get("/{log_id}", response_model=ActivityLogRead)
async def read_activity_log(
    log_id: uuid.UUID,
    repo: ActivityLogRepository = Depends(get_activity_log_repo),
    current_user: User = Depends(get_current_user)
):
    log = await repo.get_by_id(obj_id=log_id, user_id=current_user.id)
    if not log:
        raise HTTPException(status_code=404, detail="Activity log not found")
    return log

@router.put("/{log_id}", response_model=ActivityLogRead)
async def update_activity_log(
    log_id: uuid.UUID,
    log_data: ActivityLogUpdate,
    repo: ActivityLogRepository = Depends(get_activity_log_repo),
    current_user: User = Depends(get_current_user)
):
    log = await repo.get_by_id(obj_id=log_id, user_id=current_user.id)
    if not log:
        raise HTTPException(status_code=404, detail="Activity log not found")
    return await repo.update(db_obj=log, obj_in=log_data)

@router.delete("/{log_id}", status_code=204)
async def delete_activity_log(
    log_id: uuid.UUID,
    repo: ActivityLogRepository = Depends(get_activity_log_repo),
    current_user: User = Depends(get_current_user)
):
    log = await repo.get_by_id(obj_id=log_id, user_id=current_user.id)
    if not log:
        raise HTTPException(status_code=404, detail="Activity log not found")
    await repo.delete(db_obj=log)
    return