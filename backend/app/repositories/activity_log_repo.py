from sqlalchemy.ext.asyncio import AsyncSession
from app.models import ActivityLog
from app.schemas.activity_log import ActivityLogCreate, ActivityLogUpdate
from .user_owned_repo import UserOwnedRepository


class ActivityLogRepository(UserOwnedRepository[ActivityLog, ActivityLogCreate, ActivityLogUpdate]):
    def __init__(self, session: AsyncSession):
        super().__init__(model=ActivityLog, session=session)
