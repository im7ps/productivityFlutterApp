from contextlib import asynccontextmanager
from fastapi import FastAPI, Request, status
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import JSONResponse
import structlog

from uvicorn.middleware.proxy_headers import ProxyHeadersMiddleware

from app.api.v1.routers import auth, users, dimensions, actions, daily_logs, consultant, chat
from app.core.exceptions import (
    ResourceNotFound,
    EntityAlreadyExists,
    InvalidCredentials,
    DomainValidationError,
)
from app.core.config import settings
from app.core.logging import configure_logging
from slowapi import _rate_limit_exceeded_handler
from slowapi.errors import RateLimitExceeded
from app.core.rate_limit import limiter

from langgraph.checkpoint.postgres.aio import AsyncPostgresSaver
from app.services.chat_graph import compile_graph


# Inizializza il logging strutturato prima della creazione dell'app
configure_logging()
logger = structlog.get_logger()

@asynccontextmanager
async def lifespan(app: FastAPI):
    # Questo codice viene eseguito all'avvio dell'applicazione
    logger.info("Application starting", env=settings.ENVIRONMENT)
    
    # Configurazione LangChain / LangSmith Tracing
    import os
    if settings.LANGCHAIN_API_KEY:
        os.environ["LANGCHAIN_TRACING_V2"] = settings.LANGCHAIN_TRACING_V2
        os.environ["LANGCHAIN_API_KEY"] = settings.LANGCHAIN_API_KEY
        os.environ["LANGCHAIN_PROJECT"] = settings.LANGCHAIN_PROJECT
        logger.info("LangChain tracing enabled", project=settings.LANGCHAIN_PROJECT)
    
    conn_string = os.getenv("DATABASE_URL")
    async with AsyncPostgresSaver.from_conn_string(conn_string) as checkpointer:
        await checkpointer.setup()
        compile_graph(checkpointer)
        yield
    # Questo codice viene eseguito allo spegnimento dell'applicazione
    logger.info("Application shutting down")


app = FastAPI(
    title="What I've Done API",
    description="Backend for the What I've Done productivity tracker.",
    version="0.1.0",
    lifespan=lifespan
)

# Configurazione Proxy Headers
app.add_middleware(ProxyHeadersMiddleware, trusted_hosts=["*"])

# Configurazione Rate Limiting
app.state.limiter = limiter
app.add_exception_handler(RateLimitExceeded, _rate_limit_exceeded_handler)

# Configurazione CORS
app.add_middleware(
    CORSMiddleware,
    # Conversione rigorosa da AnyHttpUrl a stringa per evitare errori di serializzazione
    allow_origins=[str(origin) for origin in settings.BACKEND_CORS_ORIGINS],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

@app.exception_handler(ResourceNotFound)
async def resource_not_found_handler(request: Request, exc: ResourceNotFound):
    return JSONResponse(
        status_code=status.HTTP_404_NOT_FOUND,
        content={"detail": exc.message},
    )

@app.exception_handler(EntityAlreadyExists)
async def entity_already_exists_handler(request: Request, exc: EntityAlreadyExists):
    return JSONResponse(
        status_code=status.HTTP_409_CONFLICT,
        content={"detail": exc.message},
    )

@app.exception_handler(InvalidCredentials)
async def invalid_credentials_handler(request: Request, exc: InvalidCredentials):
    return JSONResponse(
        status_code=status.HTTP_401_UNAUTHORIZED,
        content={"detail": exc.message},
    )

@app.exception_handler(DomainValidationError)
async def domain_validation_error_handler(request: Request, exc: DomainValidationError):
    return JSONResponse(
        status_code=status.HTTP_400_BAD_REQUEST,
        content={"detail": exc.message},
    )

# Include i router delle API
app.include_router(auth.router, prefix="/api/v1/auth", tags=["auth"])
app.include_router(users.router, prefix="/api/v1/users", tags=["users"])
app.include_router(dimensions.router, prefix="/api/v1/dimensions", tags=["dimensions"])
app.include_router(actions.router, prefix="/api/v1/actions", tags=["actions"])
app.include_router(daily_logs.router, prefix="/api/v1/daily-logs", tags=["daily-logs"])
app.include_router(consultant.router, prefix="/api/v1/consultant", tags=["consultant"])
app.include_router(chat.router, prefix="/api/v1/chat", tags=["chat"])


@app.get("/")
def read_root():
    return {"message": "Welcome to the What I've Done API"}
