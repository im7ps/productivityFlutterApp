from sqlmodel import Session
from app.models import ActivityLog
from app.schemas.activity_log import ActivityLogCreate, ActivityLogUpdate
from .base_repo import BaseRepository


class ActivityLogRepository(BaseRepository[ActivityLog, ActivityLogCreate, ActivityLogUpdate]):
    def __init__(self, session: Session):
        super().__init__(model=ActivityLog, session=session)

