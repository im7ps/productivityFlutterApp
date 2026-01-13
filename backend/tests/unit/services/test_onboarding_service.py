import pytest
from unittest.mock import AsyncMock, MagicMock
from app.services.onboarding_service import OnboardingService, QUIZ_CONFIG
from app.schemas.onboarding import QuizSubmission, QuizAnswer
from app.models.user import User
from app.schemas.user import UserUpdateDB
from app.repositories.user_repo import UserRepository

@pytest.mark.asyncio
async def test_onboarding_process_logic():
    # 1. Setup Mock User
    user = User(
        username="testuser", 
        email="test@test.com", 
        hashed_password="...",
        stat_strength=10,
        stat_endurance=10,
        stat_intelligence=10,
        stat_focus=10
    )
    
    # 2. Setup Mock Repo
    mock_repo = AsyncMock(spec=UserRepository)
    
    # Setup del comportamento del mock: restituisce l'utente aggiornato
    # Simula la logica del DB che applica i cambiamenti
    async def mock_update(db_user, user_update):
        update_data = user_update.model_dump(exclude_unset=True)
        for key, value in update_data.items():
            setattr(db_user, key, value)
        return db_user

    mock_repo.update.side_effect = mock_update

    # 3. Instantiate Service with Mock Repo
    service = OnboardingService(user_repo=mock_repo)

    # 4. Prepare Submission
    # Physical Exercise -> Q1: "phys_freq" -> Val 3 ("5+") -> STR+3, END+3
    # Intellectual -> Q1: "int_read" -> Val 0 ("0") -> INT-1
    submission = QuizSubmission(answers=[
        QuizAnswer(question_id="phys_freq", selected_value=3),
        QuizAnswer(question_id="int_read", selected_value=0),
    ])

    # 5. Execute
    result = await service.process_onboarding(user, submission)

    # 6. Assertions
    # Base 10.
    # STR: 10 + 3 = 13
    # END: 10 + 3 = 13
    # INT: 10 - 1 = 9
    # FOC: 10 + 0 = 10
    
    assert result.user.stat_strength == 13
    assert result.user.stat_endurance == 13
    assert result.user.stat_intelligence == 9
    assert result.user.stat_focus == 10
    assert result.user.is_onboarding_completed is True

    # Verify Repo Interaction
    mock_repo.update.assert_called_once()
    # Verifica che sia stato passato un UserUpdateDB, non un dict o altro
    args = mock_repo.update.call_args
    assert isinstance(args[1]['user_update'], UserUpdateDB)

@pytest.mark.asyncio
async def test_onboarding_manifest_structure():
    # Service can be instantiated with None repo for this test as it doesn't use it
    service = OnboardingService(user_repo=MagicMock())
    manifest = service.get_quiz_manifest()
    
    assert len(manifest.categories) == 3
    
    first_cat = manifest.categories[0]
    assert first_cat.id == "physical_exercise"
    assert len(first_cat.questions) == 3
    
    first_q = first_cat.questions[0]
    assert hasattr(first_q.options[0], "value")
    # Check that modifiers are NOT present (pydantic filtering)
    assert not hasattr(first_q.options[0], "modifiers")