from sqlmodel import Session
from app.models import DailyLog
from app.schemas.daily_log import DailyLogCreate, DailyLogUpdate
from .base_repo import BaseRepository


class DailyLogRepository(BaseRepository[DailyLog, DailyLogCreate, DailyLogUpdate]):
    def __init__(self, session: Session):
        super().__init__(model=DailyLog, session=session)

