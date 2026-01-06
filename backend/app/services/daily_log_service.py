from typing import List
import uuid

from app.core.exceptions import ResourceNotFound
from app.models.daily_log import DailyLog
from app.repositories.daily_log_repo import DailyLogRepository
from app.schemas.daily_log import DailyLogCreate, DailyLogUpdate


class DailyLogService:
    def __init__(self, daily_log_repo: DailyLogRepository):
        self.daily_log_repo = daily_log_repo

    async def create_daily_log(self, log_create: DailyLogCreate, user_id: uuid.UUID) -> DailyLog:
        """
        Create a new daily log for the user.
        """
        return await self.daily_log_repo.create(obj_in=log_create, user_id=user_id)

    async def get_daily_logs_by_user(self, user_id: uuid.UUID) -> List[DailyLog]:
        """
        Retrieve all daily logs belonging to the user.
        """
        return await self.daily_log_repo.get_all_by_user(user_id=user_id)

    async def get_daily_log_by_id(self, log_id: uuid.UUID, user_id: uuid.UUID) -> DailyLog:
        """
        Retrieve a specific daily log by ID and user ID.
        Raises ResourceNotFound if the log does not exist.
        """
        log = await self.daily_log_repo.get_by_id(obj_id=log_id, user_id=user_id)
        if not log:
            raise ResourceNotFound(f"Daily log with id {log_id} not found")
        return log

    async def update_daily_log(
        self, log_id: uuid.UUID, log_update: DailyLogUpdate, user_id: uuid.UUID
    ) -> DailyLog:
        """
        Update an existing daily log.
        Raises ResourceNotFound if the log does not exist.
        """
        log = await self.get_daily_log_by_id(log_id, user_id)
        return await self.daily_log_repo.update(db_obj=log, obj_in=log_update)

    async def delete_daily_log(self, log_id: uuid.UUID, user_id: uuid.UUID) -> None:
        """
        Delete a daily log.
        Raises ResourceNotFound if the log does not exist.
        """
        log = await self.get_daily_log_by_id(log_id, user_id)
        await self.daily_log_repo.delete(db_obj=log)
