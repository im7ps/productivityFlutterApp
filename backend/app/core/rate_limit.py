from slowapi import Limiter
from slowapi.util import get_remote_address
from app.core.config import settings

# Istanza globale del Limiter
# key_func usa l'IP remoto per identificare il client
limiter = Limiter(key_func=get_remote_address, enabled=settings.RATE_LIMIT_ENABLED)
