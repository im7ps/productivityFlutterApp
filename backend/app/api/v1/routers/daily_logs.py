from fastapi import APIRouter, Depends
import uuid
from typing import List

from app.schemas.daily_log import DailyLogCreate, DailyLogRead, DailyLogUpdate
from app.api.v1.deps import CurrentUser, get_daily_log_service
from app.services.daily_log_service import DailyLogService

router = APIRouter()

@router.post("", response_model=DailyLogRead)
async def create_daily_log(
    log_data: DailyLogCreate,
    current_user: CurrentUser,
    service: DailyLogService = Depends(get_daily_log_service)
):
    return await service.create_daily_log(log_create=log_data, user_id=current_user.id)

@router.get("", response_model=List[DailyLogRead])
async def read_daily_logs(
    current_user: CurrentUser,
    service: DailyLogService = Depends(get_daily_log_service)
):
    return await service.get_daily_logs_by_user(user_id=current_user.id)

@router.get("/{log_id}", response_model=DailyLogRead)
async def read_daily_log(
    log_id: uuid.UUID,
    current_user: CurrentUser,
    service: DailyLogService = Depends(get_daily_log_service)
):
    return await service.get_daily_log_by_id(log_id=log_id, user_id=current_user.id)

@router.put("/{log_id}", response_model=DailyLogRead)
async def update_daily_log(
    log_id: uuid.UUID,
    log_data: DailyLogUpdate,
    current_user: CurrentUser,
    service: DailyLogService = Depends(get_daily_log_service)
):
    return await service.update_daily_log(
        log_id=log_id, log_update=log_data, user_id=current_user.id
    )

@router.delete("/{log_id}", status_code=204)
async def delete_daily_log(
    log_id: uuid.UUID,
    current_user: CurrentUser,
    service: DailyLogService = Depends(get_daily_log_service)
):
    await service.delete_daily_log(log_id=log_id, user_id=current_user.id)
