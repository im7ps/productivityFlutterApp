from fastapi import APIRouter, Depends
from sqlalchemy.ext.asyncio import AsyncSession
import uuid
from typing import List

from app.database.session import get_session
from app.schemas.activity_log import ActivityLogCreate, ActivityLogRead, ActivityLogUpdate
from app.api.v1.deps import CurrentUser
from app.repositories.activity_log_repo import ActivityLogRepository
from app.services.activity_log_service import ActivityLogService

router = APIRouter()

def get_activity_log_service(session: AsyncSession = Depends(get_session)) -> ActivityLogService:
    repo = ActivityLogRepository(session)
    return ActivityLogService(session=session, activity_log_repo=repo)

@router.post("", response_model=ActivityLogRead)
async def create_activity_log(
    log_data: ActivityLogCreate,
    current_user: CurrentUser,
    service: ActivityLogService = Depends(get_activity_log_service)
):
    return await service.create_activity_log(log_create=log_data, user_id=current_user.id)

@router.get("", response_model=List[ActivityLogRead])
async def read_activity_logs(
    current_user: CurrentUser,
    service: ActivityLogService = Depends(get_activity_log_service)
):
    return await service.get_activity_logs_by_user(user_id=current_user.id)

@router.get("/{log_id}", response_model=ActivityLogRead)
async def read_activity_log(
    log_id: uuid.UUID,
    current_user: CurrentUser,
    service: ActivityLogService = Depends(get_activity_log_service)
):
    return await service.get_activity_log_by_id(log_id=log_id, user_id=current_user.id)

@router.put("/{log_id}", response_model=ActivityLogRead)
async def update_activity_log(
    log_id: uuid.UUID,
    log_data: ActivityLogUpdate,
    current_user: CurrentUser,
    service: ActivityLogService = Depends(get_activity_log_service)
):
    return await service.update_activity_log(
        log_id=log_id, log_update=log_data, user_id=current_user.id
    )

@router.delete("/{log_id}", status_code=204)
async def delete_activity_log(
    log_id: uuid.UUID,
    current_user: CurrentUser,
    service: ActivityLogService = Depends(get_activity_log_service)
):
    await service.delete_activity_log(log_id=log_id, user_id=current_user.id)