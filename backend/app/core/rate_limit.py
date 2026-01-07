from slowapi import Limiter
from slowapi.util import get_remote_address

# Istanza globale del Limiter
# key_func usa l'IP remoto per identificare il client
limiter = Limiter(key_func=get_remote_address)
