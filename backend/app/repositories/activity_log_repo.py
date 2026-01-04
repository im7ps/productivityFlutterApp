import uuid
from typing import List
from sqlmodel import Session, select
from app.models import ActivityLog
from app.schemas.activity_log import ActivityLogCreate, ActivityLogUpdate

class ActivityLogRepository:
    def __init__(self, session: Session):
        self.session = session

    def create_activity_log(self, activity_log_create: ActivityLogCreate, user_id: uuid.UUID) -> ActivityLog:
        db_log = ActivityLog(
            **activity_log_create.model_dump(),
            user_id=user_id
        )
        self.session.add(db_log)
        self.session.commit()
        self.session.refresh(db_log)
        return db_log

    def get_activity_log_by_id(self, log_id: uuid.UUID, user_id: uuid.UUID) -> ActivityLog | None:
        statement = select(ActivityLog).where(ActivityLog.id == log_id, ActivityLog.user_id == user_id)
        return self.session.exec(statement).first()

    def get_all_activity_logs_by_user(self, user_id: uuid.UUID) -> List[ActivityLog]:
        statement = select(ActivityLog).where(ActivityLog.user_id == user_id)
        return self.session.exec(statement).all()

    def update_activity_log(self, log: ActivityLog, log_update: ActivityLogUpdate) -> ActivityLog:
        update_data = log_update.model_dump(exclude_unset=True)
        for key, value in update_data.items():
            setattr(log, key, value)
        
        self.session.add(log)
        self.session.commit()
        self.session.refresh(log)
        return log

    def delete_activity_log(self, log: ActivityLog) -> None:
        self.session.delete(log)
        self.session.commit()
