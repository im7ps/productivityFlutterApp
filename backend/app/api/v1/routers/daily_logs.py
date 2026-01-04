from fastapi import APIRouter, Depends, HTTPException
from sqlmodel import Session
import uuid
from app.database.session import get_session
from app.schemas.daily_log import DailyLogCreate, DailyLogRead, DailyLogUpdate
from app.models import User
from typing import List
from app.api.v1.routers.auth import get_current_user
from app.repositories import DailyLogRepository

router = APIRouter()

def get_daily_log_repo(session: Session = Depends(get_session)) -> DailyLogRepository:
    return DailyLogRepository(session)

@router.post("", response_model=DailyLogRead)
def create_daily_log(
    log_data: DailyLogCreate,
    repo: DailyLogRepository = Depends(get_daily_log_repo),
    current_user: User = Depends(get_current_user)
):
    return repo.create_daily_log(daily_log_create=log_data, user_id=current_user.id)

@router.get("", response_model=List[DailyLogRead])
def read_daily_logs(
    repo: DailyLogRepository = Depends(get_daily_log_repo),
    current_user: User = Depends(get_current_user)
):
    return repo.get_all_daily_logs_by_user(user_id=current_user.id)

@router.get("/{log_id}", response_model=DailyLogRead)
def read_daily_log(
    log_id: uuid.UUID,
    repo: DailyLogRepository = Depends(get_daily_log_repo),
    current_user: User = Depends(get_current_user)
):
    log = repo.get_daily_log_by_id(log_id=log_id, user_id=current_user.id)
    if not log:
        raise HTTPException(status_code=404, detail="Daily log not found")
    return log

@router.put("/{log_id}", response_model=DailyLogRead)
def update_daily_log(
    log_id: uuid.UUID,
    log_data: DailyLogUpdate,
    repo: DailyLogRepository = Depends(get_daily_log_repo),
    current_user: User = Depends(get_current_user)
):
    log = repo.get_daily_log_by_id(log_id=log_id, user_id=current_user.id)
    if not log:
        raise HTTPException(status_code=404, detail="Daily log not found")
    return repo.update_daily_log(log=log, log_update=log_data)

@router.delete("/{log_id}", status_code=204)
def delete_daily_log(
    log_id: uuid.UUID,
    repo: DailyLogRepository = Depends(get_daily_log_repo),
    current_user: User = Depends(get_current_user)
):
    log = repo.get_daily_log_by_id(log_id=log_id, user_id=current_user.id)
    if not log:
        raise HTTPException(status_code=404, detail="Daily log not found")
    repo.delete_daily_log(log=log)
    return
