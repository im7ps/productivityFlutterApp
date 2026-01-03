from fastapi import FastAPI
from app.api.v1.routers import auth, users, categories

app = FastAPI(title="Productivity Tracker API")

app.include_router(auth.router, prefix="/api/v1/auth", tags=["auth"])
app.include_router(users.router, prefix="/api/v1/users", tags=["users"])
app.include_router(categories.router, prefix="/api/v1/categories", tags=["categories"])

@app.get("/")
def read_root():
    return {"status": "ok"}
