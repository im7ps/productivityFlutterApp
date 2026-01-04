import uuid
from typing import List
from sqlmodel import Session, select
from app.models import DailyLog
from app.schemas.daily_log import DailyLogCreate, DailyLogUpdate

class DailyLogRepository:
    def __init__(self, session: Session):
        self.session = session

    def create_daily_log(self, daily_log_create: DailyLogCreate, user_id: uuid.UUID) -> DailyLog:
        db_log = DailyLog(
            **daily_log_create.model_dump(),
            user_id=user_id
        )
        self.session.add(db_log)
        self.session.commit()
        self.session.refresh(db_log)
        return db_log

    def get_daily_log_by_id(self, log_id: uuid.UUID, user_id: uuid.UUID) -> DailyLog | None:
        statement = select(DailyLog).where(DailyLog.id == log_id, DailyLog.user_id == user_id)
        return self.session.exec(statement).first()

    def get_all_daily_logs_by_user(self, user_id: uuid.UUID) -> List[DailyLog]:
        statement = select(DailyLog).where(DailyLog.user_id == user_id)
        return self.session.exec(statement).all()

    def update_daily_log(self, log: DailyLog, log_update: DailyLogUpdate) -> DailyLog:
        update_data = log_update.model_dump(exclude_unset=True)
        for key, value in update_data.items():
            setattr(log, key, value)
        
        self.session.add(log)
        self.session.commit()
        self.session.refresh(log)
        return log

    def delete_daily_log(self, log: DailyLog) -> None:
        self.session.delete(log)
        self.session.commit()
