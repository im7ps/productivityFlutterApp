import random
from locust import HttpUser, task, between
import string
from datetime import datetime

def random_string(length=10):
    return ''.join(random.choices(string.ascii_letters + string.digits, k=length))

class ProductivityUser(HttpUser):
    wait_time = between(1, 3) # Simula un utente che clicca ogni 1-3 secondi
    token = None
    user_data = None

    def on_start(self):
        """
        Eseguito quando l'utente simulato 'nasce'.
        Si registra e fa il login per ottenere il token.
        """
        username = f"user{random_string(8)}"
        password = "Password123!"
        email = f"{username}@test.com"
        
        self.user_data = {
            "username": username,
            "password": password,
            "email": email
        }

        # 1. Registrazione (Stress test per hashing password ASYNC)
        with self.client.post("/api/v1/auth/register", json=self.user_data, catch_response=True) as response:
            if response.status_code == 201:
                response.success()
            elif response.status_code == 409:
                # Se l'utente esiste già (caso raro col random), non è un errore del server
                response.success()
            else:
                response.failure(f"Signup failed: {response.text}")
                return

        # 2. Login (Stress test per verify password ASYNC)
        # Il login aspetta un x-www-form-urlencoded
        login_data = {
            "username": username,
            "password": password
        }
        with self.client.post("/api/v1/auth/login", data=login_data, catch_response=True) as response:
            if response.status_code == 200:
                self.token = response.json()["access_token"]
                response.success()
            else:
                response.failure(f"Login failed: {response.text}")

    @task(3)
    def get_categories(self):
        """Scarica le categorie. Verifica performance indici DB."""
        if not self.token:
            return
        
        headers = {"Authorization": f"Bearer {self.token}"}
        self.client.get("/api/v1/categories", headers=headers)

    @task(1)
    def create_activity(self):
        """Crea un'attività dummy. Scrittura su DB."""
        if not self.token:
            return
            
        headers = {"Authorization": f"Bearer {self.token}"}
        activity_data = {
            "start_time": datetime.utcnow().isoformat(),
            "description": "Load Testing Activity",
            # Category ID opzionale, lo omettiamo per semplicità
        }
        self.client.post("/api/v1/activity-logs", json=activity_data, headers=headers)

    @task(1)
    def do_onboarding(self):
        """
        Simula il flusso di onboarding:
        1. Scarica il quiz
        2. Invia risposte random
        """
        if not self.token:
            return
        
        headers = {"Authorization": f"Bearer {self.token}"}
        
        # 1. Fetch Quiz
        with self.client.get("/api/v1/onboarding/quiz", headers=headers, catch_response=True) as response:
            if response.status_code != 200:
                response.failure(f"Get Quiz failed: {response.status_code}")
                return
            quiz_data = response.json()
        
        # 2. Build Answers
        answers = []
        for category in quiz_data.get("categories", []):
            for question in category.get("questions", []):
                options = question.get("options", [])
                if options:
                    # Pick a random option
                    selected = random.choice(options)
                    answers.append({
                        "question_id": question["id"],
                        "selected_value": selected["value"]
                    })
        
        # 3. Submit
        payload = {"answers": answers}
        with self.client.post("/api/v1/onboarding/submit", json=payload, headers=headers, catch_response=True) as response:
            if response.status_code == 200:
                response.success()
            else:
                response.failure(f"Submit Quiz failed: {response.text}")
