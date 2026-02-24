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
        # structlog.stdlib.filter_by_level, # Removed to fix AttributeError with foreign logs
        structlog.processors.TimeStamper(fmt="iso"),
        structlog.stdlib.add_logger_name,
        structlog.stdlib.add_log_level,
        structlog.stdlib.PositionalArgumentsFormatter(),
        structlog.processors.StackInfoRenderer(),
        # format_exc_info removed: ConsoleRenderer handles exceptions natively;
        # ExceptionRenderer is used for JSON output in production.
        structlog.processors.UnicodeDecoder(),
    ]

    # Pipeline for structlog.get_logger() calls
    structlog_processors = shared_processors + [
        # Prepare event dict for stdlib logging (prevents double-rendering)
        structlog.stdlib.ProcessorFormatter.wrap_for_formatter,
    ]

    structlog.configure(
        processors=structlog_processors,
        logger_factory=structlog.stdlib.LoggerFactory(),
        wrapper_class=structlog.stdlib.BoundLogger,
        cache_logger_on_first_use=True,
    )

    # Renderer selection based on environment
    if settings.ENVIRONMENT == "local":
        final_processors = [
            # Remove internal keys added by wrap_for_formatter
            structlog.stdlib.ProcessorFormatter.remove_processors_meta,
            structlog.dev.ConsoleRenderer()
        ]
    else:
        final_processors = [
            structlog.stdlib.ProcessorFormatter.remove_processors_meta,
            # Render exceptions as structured dicts inside the JSON payload
            structlog.processors.ExceptionRenderer(),
            structlog.processors.JSONRenderer()
        ]

    # Configure standard library logging to use structlog
    formatter = structlog.stdlib.ProcessorFormatter(
        # Foreign logs (e.g. uvicorn, sqlalchemy) go through shared processors
        foreign_pre_chain=shared_processors,
        # All logs (structlog + foreign) go through final processors (rendering)
        processors=final_processors,
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
