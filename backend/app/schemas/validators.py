import re
from typing import Optional

# --- CONSTANTS (Single Source of Truth) ---
USERNAME_MIN_LEN = 3
USERNAME_MAX_LEN = 20
USERNAME_REGEX = r"^[a-zA-Z0-9_]+$" # Alphanumeric only + underscore

PASSWORD_MIN_LEN = 8
PASSWORD_MAX_LEN = 72
PASSWORD_REQ_UPPER = r"[A-Z]"
PASSWORD_REQ_LOWER = r"[a-z]"
PASSWORD_REQ_DIGIT = r"\d"
PASSWORD_REQ_SPECIAL = r"[!@#$%^&*(),.?\":{}|<>]"


def validate_password_strength(v: Optional[str]) -> Optional[str]:
    """Valida la complessità della password."""
    if v is None:
        return v
    if len(v) < PASSWORD_MIN_LEN:
        raise ValueError(f"Password must be at least {PASSWORD_MIN_LEN} characters long")
    if len(v) > PASSWORD_MAX_LEN:
        raise ValueError(f"Password must not exceed {PASSWORD_MAX_LEN} characters")
    if not re.search(PASSWORD_REQ_UPPER, v):
        raise ValueError("Password must contain at least one uppercase letter")
    if not re.search(PASSWORD_REQ_LOWER, v):
        raise ValueError("Password must contain at least one lowercase letter")
    if not re.search(PASSWORD_REQ_DIGIT, v):
        raise ValueError("Password must contain at least one digit")
    if not re.search(PASSWORD_REQ_SPECIAL, v):
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
    if not (USERNAME_MIN_LEN <= len(v) <= USERNAME_MAX_LEN):
        raise ValueError(f"Username must be between {USERNAME_MIN_LEN} and {USERNAME_MAX_LEN} characters")
    
    # We use regex here to enforce the Single Source of Truth, replacing isalnum()
    # which is subtly different (allows other unicode alphanums) but close enough.
    # To be strictly identical to previous isalnum behavior we should keep isalnum
    # but the requirement is "Single Source of Truth via constants".
    # Using the regex constant is safer for consistency with tests.
    if not re.match(USERNAME_REGEX, v):
        raise ValueError("Username must be alphanumeric")
    return v
