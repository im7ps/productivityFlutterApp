from fastapi import FastAPI, Depends, HTTPException, status, Request
from fastapi.responses import JSONResponse

from models import User, UserCreate, UserPublic, Token, Category, CategoryCreate, CategoryRead
from typing import List

from sqlmodel import Session, select

from database import get_session

from fastapi.security import OAuth2PasswordRequestForm, OAuth2PasswordBearer
from auth_utils import verify_password, create_access_token, get_password_hash, SECRET_KEY, ALGORITHM
from jose import JWTError, jwt


import logging
import traceback

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

oauth2_scheme = OAuth2PasswordBearer(tokenUrl="token")

app = FastAPI(title="Productivity Tracker API")


# --- GLOBAL EXCEPTION HANDLER ---
@app.exception_handler(Exception)
async def global_exception_handler(request: Request, exc: Exception):
    # 1. Logga l'errore completo nel server (visibile con 'docker-compose logs')
    logger.error(f"🔥 ERRORE NON GESTITO SU {request.url}")
    logger.error(traceback.format_exc())
    
    # 2. Risponde al Frontend in modo pulito
    return JSONResponse(
        status_code=500,
        content={"detail": "Errore interno del server. Contatta l'amministratore o controlla i log."},
    )


@app.get("/")
def read_root():
    return {"status": "Database collegato e tabelle create!"}


@app.post("/signup", response_model=UserPublic, status_code=status.HTTP_201_CREATED)
def signup(user_data: UserCreate, session: Session = Depends(get_session)):
    # 1. Check if user exists
    statement = select(User).where((User.username == user_data.username) | (User.email == user_data.email))
    existing_user = session.exec(statement).first()
    
    if existing_user:
        raise HTTPException(status_code=400, detail="Username o Email già registrati")

    # 2. Hash the password (ensure input is within limits)
    # If you didn't add max_length to Pydantic, truncate here:
    safe_password = user_data.password[:72]
    hashed_pwd = get_password_hash(safe_password)

    new_user = User(
        username=user_data.username,
        email=user_data.email,
        hashed_password=hashed_pwd
    )

    # 3. Save
    session.add(new_user)
    session.commit()
    session.refresh(new_user)
    
    return new_user


@app.post("/token", response_model=Token)
def login(
    form_data: OAuth2PasswordRequestForm = Depends(), 
    session: Session = Depends(get_session)
):
    # 1. Cerchiamo l'utente nel DB tramite lo username
    statement = select(User).where(User.username == form_data.username)
    user = session.exec(statement).first()

    # 2. Verifichiamo se l'utente esiste e se la password è corretta
    if not user or not verify_password(form_data.password, user.hashed_password):
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Username o password errati",
            headers={"WWW-Authenticate": "Bearer"},
        )

    # 3. Generiamo il token JWT (usiamo lo username o l'id come 'sub')
    access_token = create_access_token(data={"sub": user.username})
    
    return {"access_token": access_token, "token_type": "bearer"}


def get_current_user(token: str = Depends(oauth2_scheme), session: Session = Depends(get_session)):
    credentials_exception = HTTPException(
        status_code=status.HTTP_401_UNAUTHORIZED,
        detail="Impossibile validare le credenziali",
        headers={"WWW-Authenticate": "Bearer"},
    )
    try:
        payload = jwt.decode(token, SECRET_KEY, algorithms=[ALGORITHM])
        username: str = payload.get("sub")
        if username is None:
            raise credentials_exception
    except JWTError:
        raise credentials_exception
        
    user = session.exec(select(User).where(User.username == username)).first()
    if user is None:
        raise credentials_exception
    return user


@app.get("/users/me", response_model=UserPublic)
def read_users_me(current_user: User = Depends(get_current_user)):
    return current_user


@app.post("/categories/", response_model=CategoryRead)
def create_category(
    category_data: CategoryCreate, 
    session: Session = Depends(get_session),
    current_user: User = Depends(get_current_user)
):
    try:
        # Metodo più sicuro per creare l'istanza:
        # Trasformiamo i dati in dizionario e aggiungiamo l'ID utente PRIMA di creare l'oggetto
        # Questo evita errori di validazione se user_id è obbligatorio nel modello
        category_dict = category_data.dict()
        category_dict["user_id"] = current_user.id
        
        new_category = Category(**category_dict)
        
        session.add(new_category)
        session.commit()
        session.refresh(new_category)
        
        return new_category

    except Exception as e:
        # Stampa l'errore completo nei log di Docker
        print("❌ ERRORE CREAZIONE CATEGORIA:")
        traceback.print_exc()
        
        # Restituisci un errore leggibile su Swagger/App
        raise HTTPException(
            status_code=500, 
            detail=f"Errore durante il salvataggio: {str(e)}"
        )


@app.get("/categories/", response_model=List[CategoryRead])
def read_categories(
    session: Session = Depends(get_session),
    current_user: User = Depends(get_current_user)
):
    # Restituisce solo le categorie dell'utente loggato
    statement = select(Category).where(Category.user_id == current_user.id)
    results = session.exec(statement).all()
    return results
