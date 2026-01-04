from sqlalchemy.ext.asyncio import AsyncSession
from app.models import DailyLog
from app.schemas.daily_log import DailyLogCreate, DailyLogUpdate
from .base_repo import BaseRepository


class DailyLogRepository(BaseRepository[DailyLog, DailyLogCreate, DailyLogUpdate]):
    def __init__(self, session: AsyncSession):
        super().__init__(model=DailyLog, session=session)