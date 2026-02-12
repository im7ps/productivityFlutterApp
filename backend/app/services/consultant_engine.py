import uuid
import random
from typing import List, Set
from datetime import datetime
from app.models.action import Action
from app.repositories.action_repo import ActionRepo

class ConsultantEngine:
    """
    Dedicated engine for calculating task proposals (The 'Consultant').
    This is separated from the Service to allow for complex ranking/selection algorithms.
    """

    # Seeds to ensure the user always has something to do
    SEED_TASKS = [
        {"description": "Meditazione 15 minuti", "category": "Energia", "difficulty": 1, "fulfillment": 4, "slug": "energy"},
        {"description": "Suonare uno strumento", "category": "Passione", "difficulty": 2, "fulfillment": 5, "slug": "passion"},
        {"description": "Pulizia profonda 20 min", "category": "Dovere", "difficulty": 3, "fulfillment": 3, "slug": "duties"},
        {"description": "Esercizio Fisico Intenso", "category": "Energia", "difficulty": 5, "fulfillment": 4, "slug": "energy"},
        {"description": "Lettura Formativa", "category": "Anima", "difficulty": 2, "fulfillment": 5, "slug": "soul"},
        {"description": "Revisione Obiettivi", "category": "Dovere", "difficulty": 1, "fulfillment": 3, "slug": "duties"},
        {"description": "Connessione Sociale", "category": "Relazioni", "difficulty": 1, "fulfillment": 4, "slug": "relationships"},
    ]

    def __init__(self, action_repo: ActionRepo):
        self.action_repo = action_repo

    async def generate_proposals(self, user_id: uuid.UUID, count: int = 5) -> List[Action]:
        """
        Orchestrates the selection of tasks based on history and seeds.
        """
        # 1. Get user history (all tasks ever created/completed)
        history = await self.action_repo.get_all_by_user(user_id)
        
        # 2. Get tasks completed TODAY (to avoid proposing them again)
        today_start = datetime.utcnow().replace(hour=0, minute=0, second=0, microsecond=0)
        completed_today = {
            a.description.lower() for a in history 
            if a.status == "COMPLETED" and a.start_time >= today_start
        }

        # 3. Build a 'Portfolio' of unique tasks from history
        portfolio = self._extract_unique_tasks(history)
        
        # 4. Filter out tasks completed today from portfolio
        available_portfolio = [
            t for t in portfolio 
            if t['description'].lower() not in completed_today
        ]

        # 5. Add Seed Tasks to the pool if they are not already in portfolio/completed today
        pool = self._merge_seeds_into_pool(available_portfolio, completed_today)

        # 6. Select the best candidates (Logic can be expanded here)
        selected_tasks = self._select_balanced_subset(pool, count)

        # 7. Convert to Action models
        return self._map_to_actions(selected_tasks, user_id)

    def _extract_unique_tasks(self, history: List[Action]) -> List[dict]:
        """
        Converts history of actions into a list of unique task templates.
        """
        unique_tasks = {}
        for action in history:
            key = action.description.lower()
            if key not in unique_tasks:
                unique_tasks[key] = {
                    "description": action.description,
                    "category": action.category,
                    "difficulty": action.difficulty,
                    "fulfillment": action.fulfillment_score,
                    "dimension_id": action.dimension_id
                }
        return list(unique_tasks.values())

    def _merge_seeds_into_pool(self, portfolio: List[dict], completed_today: Set[str]) -> List[dict]:
        """
        Combines user tasks with seeds, avoiding duplicates.
        """
        pool = list(portfolio)
        portfolio_descriptions = {t['description'].lower() for t in portfolio}
        
        for seed in self.SEED_TASKS:
            desc_lower = seed['description'].lower()
            if desc_lower not in portfolio_descriptions and desc_lower not in completed_today:
                pool.append({
                    "description": seed['description'],
                    "category": seed['category'],
                    "difficulty": seed['difficulty'],
                    "fulfillment": seed['fulfillment'],
                    "dimension_id": seed['slug'] # Seed uses slug as fallback dimension_id
                })
        return pool

    def _select_balanced_subset(self, pool: List[dict], count: int) -> List[dict]:
        """
        Selection logic: currently uses weighted randomness or simple shuffle.
        Can be improved with AI or specific category balancing.
        """
        if not pool:
            return []
        
        # Simple shuffle for now, ensuring variety
        random.shuffle(pool)
        return pool[:count]

    def _map_to_actions(self, task_dicts: List[dict], user_id: uuid.UUID) -> List[Action]:
        """
        Converts task dictionaries into Action objects for the API.
        """
        actions = []
        for p in task_dicts:
            # Deterministic UUID per user + task description to keep ID stable for the same day
            proposal_id = uuid.uuid5(uuid.NAMESPACE_DNS, f"{user_id}-{p['description']}")
            actions.append(
                Action(
                    id=proposal_id,
                    description=p["description"],
                    user_id=user_id,
                    category=p["category"],
                    difficulty=p["difficulty"],
                    fulfillment_score=p["fulfillment"],
                    start_time=datetime.utcnow(),
                    dimension_id=p["dimension_id"],
                    status="PENDING"
                )
            )
        return actions
