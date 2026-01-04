from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from app.api.v1.routers import auth, users, categories, activity_logs, daily_logs
from app.core.config import settings

from app.database.session import init_db

app = FastAPI(title="Productivity Tracker API")

@app.on_event("startup")
async def on_startup():
    await init_db()

app.add_middleware(
    CORSMiddleware,
    allow_origins=settings.BACKEND_CORS_ORIGINS,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

app.include_router(auth.router, prefix="/api/v1/auth", tags=["auth"])
app.include_router(users.router, prefix="/api/v1/users", tags=["users"])
app.include_router(categories.router, prefix="/api/v1/categories", tags=["categories"])
app.include_router(activity_logs.router, prefix="/api/v1/activity-logs", tags=["activity-logs"])
app.include_router(daily_logs.router, prefix="/api/v1/daily-logs", tags=["daily-logs"])


@app.get("/")
def read_root():
    return {"status": "ok"}
