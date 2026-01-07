from typing import List
import uuid
from fastapi import HTTPException, status

from app.core.exceptions import ResourceNotFound
from app.models.activity_log import ActivityLog
from app.repositories.activity_log_repo import ActivityLogRepository
from app.schemas.activity_log import ActivityLogCreate, ActivityLogUpdate


from sqlalchemy.ext.asyncio import AsyncSession

class ActivityLogService:
    def __init__(self, session: AsyncSession, activity_log_repo: ActivityLogRepository):
        self.session = session
        self.activity_log_repo = activity_log_repo

    async def create_activity_log(self, log_create: ActivityLogCreate, user_id: uuid.UUID) -> ActivityLog:
        """
        Create a new activity log for the user.
        """
        log = await self.activity_log_repo.create(obj_in=log_create, user_id=user_id)
        await self.session.commit()
        return log

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
        Update an existing activity log with rigorous time validation.
        """
        # 1. Recupera l'oggetto esistente
        log = await self.get_activity_log_by_id(log_id, user_id)
        
        # 2. Determina i valori finali (se un campo è None nell'update, usa quello attuale del DB)
        effective_start = log_update.start_time if log_update.start_time is not None else log.start_time
        effective_end = log_update.end_time if log_update.end_time is not None else log.end_time
        
        # 3. Esegui la validazione temporale incrociata
        if effective_end is not None and effective_end <= effective_start:
             raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail="End time must be after start time"
            )

        updated_log = await self.activity_log_repo.update(db_obj=log, obj_in=log_update)
        await self.session.commit()
        return updated_log

    async def delete_activity_log(self, log_id: uuid.UUID, user_id: uuid.UUID) -> None:
        """
        Delete an activity log.
        Raises ResourceNotFound if the log does not exist.
        """
        log = await self.get_activity_log_by_id(log_id, user_id)
        await self.activity_log_repo.delete(db_obj=log)
        await self.session.commit()