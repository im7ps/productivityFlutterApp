from typing import List, Dict, Any, Final
from app.core.exceptions import DomainValidationError
from app.models.user import User
from app.schemas.onboarding import (
    QuizManifest,
    QuizCategory,
    QuizQuestion,
    QuizOption,
    QuizSubmission,
    OnboardingResult,
)
from app.schemas.user import UserUpdateDB
from app.repositories.user_repo import UserRepository

# Configurazione Immutabile
QUIZ_CONFIG: Final[Dict[str, Any]] = {
    "physical_exercise": {
        "title": "Esercizio Fisico",
        "description": "Valuta il tuo livello di attività fisica attuale.",
        "questions": [
            {
                "id": "phys_freq",
                "text": "Quante volte alla settimana fai attività fisica intensa?",
                "options": [
                    {"value": 0, "label": "0", "modifiers": {"stat_strength": -1, "stat_endurance": -1}},
                    {"value": 1, "label": "1-2", "modifiers": {"stat_strength": 1, "stat_endurance": 0}},
                    {"value": 2, "label": "3-4", "modifiers": {"stat_strength": 2, "stat_endurance": 2}},
                    {"value": 3, "label": "5+", "modifiers": {"stat_strength": 3, "stat_endurance": 3}},
                ]
            },
            {
                "id": "phys_type",
                "text": "Come descriveresti il tuo stile di vita?",
                "options": [
                    {"value": 0, "label": "Sedentario", "modifiers": {"stat_strength": -1, "stat_endurance": -2}},
                    {"value": 1, "label": "Attivo (camminate, scale)", "modifiers": {"stat_endurance": 1}},
                    {"value": 2, "label": "Sportivo", "modifiers": {"stat_strength": 2, "stat_endurance": 1}},
                ]
            },
            {
                "id": "phys_rec",
                "text": "Come ti senti dopo uno sforzo fisico?",
                "options": [
                    {"value": 0, "label": "Esausto per giorni", "modifiers": {"stat_endurance": -2}},
                    {"value": 1, "label": "Stanco ma recupero in fretta", "modifiers": {"stat_endurance": 1}},
                    {"value": 2, "label": "Energico", "modifiers": {"stat_endurance": 3, "stat_strength": 1}},
                ]
            }
        ]
    },
    "intellectual_growth": {
        "title": "Crescita Intellettuale",
        "description": "Valuta le tue abitudini di apprendimento e concentrazione.",
        "questions": [
            {
                "id": "int_read",
                "text": "Quanti libri leggi (o ascolti) al mese?",
                "options": [
                    {"value": 0, "label": "0", "modifiers": {"stat_intelligence": -1}},
                    {"value": 1, "label": "1", "modifiers": {"stat_intelligence": 1}},
                    {"value": 2, "label": "2+", "modifiers": {"stat_intelligence": 3}},
                ]
            },
            {
                "id": "int_learn",
                "text": "Quanto tempo dedichi all'apprendimento di nuove skill a settimana?",
                "options": [
                    {"value": 0, "label": "Poco o nulla", "modifiers": {"stat_intelligence": 0}},
                    {"value": 1, "label": "1-2 ore", "modifiers": {"stat_intelligence": 1, "stat_focus": 1}},
                    {"value": 2, "label": "3+ ore", "modifiers": {"stat_intelligence": 3, "stat_focus": 2}},
                ]
            },
            {
                "id": "int_focus",
                "text": "Riesci a concentrarti su un task per più di 1 ora senza distrazioni?",
                "options": [
                    {"value": 0, "label": "No, mi distraggo subito", "modifiers": {"stat_focus": -2}},
                    {"value": 1, "label": "A volte", "modifiers": {"stat_focus": 0}},
                    {"value": 2, "label": "Sì, spesso", "modifiers": {"stat_focus": 3}},
                ]
            }
        ]
    },
    "nutrition": {
        "title": "Alimentazione",
        "description": "Valuta le tue abitudini alimentari.",
        "questions": [
            {
                "id": "nut_meals",
                "text": "Quanto sono regolari i tuoi pasti?",
                "options": [
                    {"value": 0, "label": "Salto spesso i pasti", "modifiers": {"stat_endurance": -1}},
                    {"value": 1, "label": "Abbastanza regolari", "modifiers": {"stat_endurance": 1}},
                    {"value": 2, "label": "Molto regolari", "modifiers": {"stat_endurance": 2}},
                ]
            },
            {
                "id": "nut_junk",
                "text": "Quanto spesso mangi junk food?",
                "options": [
                    {"value": 0, "label": "Spesso (3+ volte a settimana)", "modifiers": {"stat_endurance": -2, "stat_strength": -1}},
                    {"value": 1, "label": "Occasionalmente", "modifiers": {"stat_endurance": 0}},
                    {"value": 2, "label": "Raramente", "modifiers": {"stat_endurance": 2}},
                ]
            },
            {
                "id": "nut_water",
                "text": "Quanta acqua bevi al giorno?",
                "options": [
                    {"value": 0, "label": "< 1 Litro", "modifiers": {"stat_focus": -1, "stat_endurance": -1}},
                    {"value": 1, "label": "1-2 Litri", "modifiers": {"stat_focus": 1, "stat_endurance": 1}},
                    {"value": 2, "label": "2+ Litri", "modifiers": {"stat_focus": 2, "stat_endurance": 2}},
                ]
            }
        ]
    }
}

class OnboardingService:
    def __init__(self, user_repo: UserRepository):
        self.user_repo = user_repo

    def get_quiz_manifest(self) -> QuizManifest:
        """
        Genera il manifesto del quiz da inviare al frontend.
        Logica pura, non richiede I/O.
        """
        categories = []
        for cat_id, cat_data in QUIZ_CONFIG.items():
            questions = []
            for q_data in cat_data["questions"]:
                options = [
                    QuizOption(value=opt["value"], label=opt["label"])
                    for opt in q_data["options"]
                ]
                questions.append(
                    QuizQuestion(id=q_data["id"], text=q_data["text"], options=options)
                )
            
            categories.append(
                QuizCategory(
                    id=cat_id,
                    title=cat_data["title"],
                    description=cat_data["description"],
                    questions=questions
                )
            )
        return QuizManifest(categories=categories)

    async def process_onboarding(
        self, user: User, submission: QuizSubmission
    ) -> OnboardingResult:
        """
        Elabora le risposte, calcola le nuove statistiche e aggiorna l'utente.
        """
        if user.is_onboarding_completed:
            # Policy: Se l'utente ha già fatto l'onboarding, sovrascriviamo? 
            # Per ora si, ma potremmo voler lanciare un'eccezione in futuro.
            pass

        # 1. Preparazione Lookup e Accumulatori
        stats_delta: Dict[str, int] = {
            "stat_strength": 0,
            "stat_endurance": 0,
            "stat_intelligence": 0,
            "stat_focus": 0,
        }

        # Flat map per accesso O(1) alle domande
        question_map = {}
        for cat_val in QUIZ_CONFIG.values():
            for q in cat_val["questions"]:
                question_map[q["id"]] = q

        # 2. Validazione e Calcolo
        for answer in submission.answers:
            question_data = question_map.get(answer.question_id)
            
            if not question_data:
                # STRICT VALIDATION: Il client ha mandato un ID domanda sconosciuto.
                raise DomainValidationError(f"Question ID '{answer.question_id}' not found in configuration.")

            # Trova l'opzione selezionata
            selected_option = next(
                (opt for opt in question_data["options"] if opt["value"] == answer.selected_value),
                None
            )
            
            if selected_option is None:
                 # STRICT VALIDATION: Il client ha mandato un valore opzione non valido.
                raise DomainValidationError(
                    f"Invalid value '{answer.selected_value}' for question '{answer.question_id}'."
                )
            
            # Applica modificatori
            if "modifiers" in selected_option:
                for stat, value in selected_option["modifiers"].items():
                    if stat in stats_delta:
                        stats_delta[stat] += value

        # 3. Preparazione DTO di Aggiornamento
        # Base stats partono da 10 (hardcoded base logic) + delta
        new_stats = {
            "stat_strength": max(0, 10 + stats_delta["stat_strength"]),
            "stat_endurance": max(0, 10 + stats_delta["stat_endurance"]),
            "stat_intelligence": max(0, 10 + stats_delta["stat_intelligence"]),
            "stat_focus": max(0, 10 + stats_delta["stat_focus"]),
            "is_onboarding_completed": True
        }

        update_dto = UserUpdateDB(**new_stats)

        # 4. Persistenza (Repository Pattern corretto)
        updated_user = await self.user_repo.update(db_user=user, user_update=update_dto)

        return OnboardingResult(
            user=updated_user,
            message="Onboarding completed successfully.",
            stats_gained=stats_delta
        )