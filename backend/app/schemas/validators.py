import re
from typing import Optional

def validate_password_strength(v: Optional[str]) -> Optional[str]:
    """Valida la complessità della password."""
    if v is None:
        return v
    if len(v) < 8:
        raise ValueError("Password must be at least 8 characters long")
    if len(v) > 72:
        raise ValueError("Password must not exceed 72 characters")
    if not re.search(r"[A-Z]", v):
        raise ValueError("Password must contain at least one uppercase letter")
    if not re.search(r"[a-z]", v):
        raise ValueError("Password must contain at least one lowercase letter")
    if not re.search(r"\d", v):
        raise ValueError("Password must contain at least one digit")
    if not re.search(r"[!@#$%^&*(),.?\":{}|<>]", v):
        raise ValueError("Password must contain at least one special character")
    return v

def validate_xss_basic(v: Optional[str]) -> Optional[str]:
    """Controllo preventivo di base per caratteri pericolosi."""
    if v is None:
        return v
    if "<" in v or ">" in v:
        raise ValueError("Input cannot contain '<' or '>' characters")
    return v

def validate_score_range(v: Optional[int]) -> Optional[int]:
    """Valida che il punteggio sia tra 1 e 5."""
    if v is None:
        return v
    if not (1 <= v <= 5):
        raise ValueError("Score must be between 1 and 5")
    return v

def validate_non_negative(v: Optional[float]) -> Optional[float]:
    """Valida che il numero non sia negativo."""
    if v is None:
        return v
    if v < 0:
        raise ValueError("Value cannot be negative")
    return v

def validate_username_format(v: Optional[str]) -> Optional[str]:
    """Valida formato e lunghezza username."""
    if v is None:
        return v
    if not (3 <= len(v) <= 20):
        raise ValueError("Username must be between 3 and 20 characters")
    if not v.isalnum():
        raise ValueError("Username must be alphanumeric")
    return v

