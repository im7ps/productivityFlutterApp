from fastapi import APIRouter, Depends
from app.api.v1.deps import get_current_user, OnboardingServiceDep
from app.models.user import User
from app.schemas.onboarding import QuizManifest, QuizSubmission, OnboardingResult

router = APIRouter()

@router.get("/quiz", response_model=QuizManifest)
async def get_onboarding_quiz(
    service: OnboardingServiceDep,
    current_user: User = Depends(get_current_user),
):
    """
    Recupera la struttura del quiz di onboarding (domande, opzioni).
    Da chiamare quando l'utente inizia il flusso di onboarding.
    """
    return service.get_quiz_manifest()

@router.post("/submit", response_model=OnboardingResult)
async def submit_onboarding_quiz(
    submission: QuizSubmission,
    service: OnboardingServiceDep,
    current_user: User = Depends(get_current_user),
):
    """
    Invia le risposte del quiz.
    Il server calcola le statistiche RPG risultanti, aggiorna l'utente 
    e segna l'onboarding come completato.
    """
    return await service.process_onboarding(user=current_user, submission=submission)