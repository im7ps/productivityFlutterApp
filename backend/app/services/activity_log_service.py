from typing import List
import uuid

from app.core.exceptions import ResourceNotFound
from app.models.activity_log import ActivityLog
from app.repositories.activity_log_repo import ActivityLogRepository
from app.schemas.activity_log import ActivityLogCreate, ActivityLogUpdate


class ActivityLogService:
    def __init__(self, activity_log_repo: ActivityLogRepository):
        self.activity_log_repo = activity_log_repo

    async def create_activity_log(self, log_create: ActivityLogCreate, user_id: uuid.UUID) -> ActivityLog:
        """
        Create a new activity log for the user.
        """
        return await self.activity_log_repo.create(obj_in=log_create, user_id=user_id)

    async def get_activity_logs_by_user(self, user_id: uuid.UUID) -> List[ActivityLog]:
        """
        Retrieve all activity logs belonging to the user.
        """
        return await self.activity_log_repo.get_all_by_user(user_id=user_id)

    async def get_activity_log_by_id(self, log_id: uuid.UUID, user_id: uuid.UUID) -> ActivityLog:
        """
        Retrieve a specific activity log by ID and user ID.
        Raises ResourceNotFound if the log does not exist.
        """
        log = await self.activity_log_repo.get_by_id(obj_id=log_id, user_id=user_id)
        if not log:
            raise ResourceNotFound(f"Activity log with id {log_id} not found")
        return log

    async def update_activity_log(
        self, log_id: uuid.UUID, log_update: ActivityLogUpdate, user_id: uuid.UUID
    ) -> ActivityLog:
        """
        Update an existing activity log.
        Raises ResourceNotFound if the log does not exist.
        """
        log = await self.get_activity_log_by_id(log_id, user_id)
        return await self.activity_log_repo.update(db_obj=log, obj_in=log_update)

    async def delete_activity_log(self, log_id: uuid.UUID, user_id: uuid.UUID) -> None:
        """
        Delete an activity log.
        Raises ResourceNotFound if the log does not exist.
        """
        log = await self.get_activity_log_by_id(log_id, user_id)
        await self.activity_log_repo.delete(db_obj=log)
