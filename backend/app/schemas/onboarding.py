from typing import List, Dict
from pydantic import Field
from app.schemas.base import TunableBaseModel
from app.schemas.user import UserPublic

# --- GET /quiz Response Schemas ---

class QuizOption(TunableBaseModel):
    value: int
    label: str
    description: str | None = None

class QuizQuestion(TunableBaseModel):
    id: str
    text: str
    options: List[QuizOption]

class QuizCategory(TunableBaseModel):
    id: str  # es: "physical_exercise"
    title: str
    description: str
    questions: List[QuizQuestion]

class QuizManifest(TunableBaseModel):
    categories: List[QuizCategory]

# --- POST /submit Request Schemas ---

class QuizAnswer(TunableBaseModel):
    question_id: str
    selected_value: int

class QuizSubmission(TunableBaseModel):
    answers: List[QuizAnswer]

# --- POST /submit Response Schemas ---

class OnboardingResult(TunableBaseModel):
    user: UserPublic
    message: str
    stats_gained: Dict[str, int]  # es: {"stat_strength": 2, "stat_focus": -1}
