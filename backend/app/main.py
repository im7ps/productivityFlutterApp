from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from app.api.v1.routers import auth, users, categories
from app.core.config import settings

app = FastAPI(title="Productivity Tracker API")

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

@app.get("/")
def read_root():
    return {"status": "ok"}
