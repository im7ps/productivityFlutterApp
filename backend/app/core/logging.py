import logging
import sys
import structlog
from app.core.config import settings

def configure_logging():
    """
    Configures structured logging for the application.
    Uses JSON formatting in production and Console formatting in local development.
    Intersects standard library logging to unify output format.
    """
    shared_processors = [
        structlog.contextvars.merge_contextvars,
        structlog.stdlib.filter_by_level,
        structlog.processors.TimeStamper(fmt="iso"),
        structlog.stdlib.add_logger_name,
        structlog.stdlib.add_log_level,
        structlog.stdlib.PositionalArgumentsFormatter(),
        structlog.processors.StackInfoRenderer(),
        structlog.processors.format_exc_info,
        structlog.processors.UnicodeDecoder(),
    ]

    if settings.ENVIRONMENT == "local":
        # Development processors (Human readable)
        processors = shared_processors + [
            structlog.dev.ConsoleRenderer()
        ]
    else:
        # Production processors (Machine readable JSON)
        processors = shared_processors + [
            structlog.processors.dict_tracebacks,
            structlog.processors.JSONRenderer()
        ]

    structlog.configure(
        processors=processors,
        logger_factory=structlog.stdlib.LoggerFactory(),
        wrapper_class=structlog.stdlib.BoundLogger,
        cache_logger_on_first_use=True,
    )

    # Configure standard library logging to use structlog
    # This captures logs from Uvicorn, SQLAlchemy, etc.
    formatter = structlog.stdlib.ProcessorFormatter(
        # These run solely on standard library log records
        foreign_pre_chain=shared_processors,
        # These run on all log records
        processors=[
            structlog.dev.ConsoleRenderer() if settings.ENVIRONMENT == "local" else structlog.processors.JSONRenderer()
        ],
    )

    # Reset root logger handlers
    root_logger = logging.getLogger()
    root_logger.handlers = []
    
    handler = logging.StreamHandler(sys.stdout)
    handler.setFormatter(formatter)
    root_logger.addHandler(handler)
    
    # Set level based on environment
    level = logging.DEBUG if settings.ENVIRONMENT == "local" else logging.INFO
    root_logger.setLevel(level)

    # Avoid duplicate logs from uvicorn (uvicorn handles its own logging setup usually, 
    # but we want to override it or let it propagate).
    # Setting propagate to True for specific loggers ensures they bubble up to our root logger.
