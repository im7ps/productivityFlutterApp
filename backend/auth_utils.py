from passlib.context import CryptContext
from datetime import datetime, timedelta, timezone
from jose import jwt

# Configurazione per l'hashing delle password
pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")

# Configurazione JWT (In produzione useremo variabili d'ambiente)
SECRET_KEY = "chiave_secreta" 
ALGORITHM = "HS256"
ACCESS_TOKEN_EXPIRE_MINUTES = 60 * 24 # Il token dura un giorno

def get_password_hash(password: str) -> str:
    return pwd_context.hash(password[:72])

def verify_password(plain_password: str, hashed_password: str) -> bool:
    return pwd_context.verify(plain_password[:72], hashed_password)

def create_access_token(data: dict):
    to_encode = data.copy()

    expire = datetime.now(timezone.utc) + timedelta(minutes=ACCESS_TOKEN_EXPIRE_MINUTES)
    
    to_encode.update({"exp": expire})
    return jwt.encode(to_encode, SECRET_KEY, algorithm=ALGORITHM)