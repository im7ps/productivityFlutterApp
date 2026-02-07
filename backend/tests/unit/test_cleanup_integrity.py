import pytest
from app.models.user import User
from app.schemas.user import UserPublic, UserUpdate, UserUpdateDB

def test_user_model_has_no_rpg_fields():
    """Verifica che il modello DB sia privo di campi RPG."""
    forbidden_fields = {
        'stat_strength', 'stat_endurance', 'stat_intelligence', 
        'stat_focus', 'is_onboarding_completed', 'daily_reached_goal'
    }
    # In SQLModel/Pydantic v2 usiamo model_fields
    current_fields = set(User.model_fields.keys())
    intersection = forbidden_fields.intersection(current_fields)
    assert not intersection, f"Residui trovati nel modello User: {intersection}"

def test_user_schemas_are_clean():
    """Verifica che tutti gli schemi utente siano privi di dati RPG."""
    forbidden_fields = {
        'stat_strength', 'is_onboarding_completed', 'daily_reached_goal'
    }
    
    schemas_to_check = [UserPublic, UserUpdate, UserUpdateDB]
    
    for schema in schemas_to_check:
        current_fields = set(schema.model_fields.keys())
        intersection = forbidden_fields.intersection(current_fields)
        assert not intersection, f"Lo schema {schema.__name__} espone ancora dati RPG: {intersection}"
