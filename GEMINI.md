# GEMINI.md

## Project Vision: Day 0 - Action Engine

**Philosophy:** The app is based on the "Day 0" philosophy: every morning resets everything. You have the opportunity to improve yourself *today*.
**Goal:** Map passions and provide immediate stimulus for practice, eliminating excuses and delays. Less planning, more execution.

---

## Architecture & Conventions

### Backend (Python/FastAPI)
- **Stack:** Python 3.10+, FastAPI, SQLModel (Async), Alembic, PostgreSQL, Docker.
- **Architecture:** Clean Architecture (Router -> Service -> Repository -> DB).
- **Security:** JWT Auth, Pydantic v2 Strict Validation.
- **Key Logic:**
  - **Rank Engine:** Calculates daily score based on completed actions vs time blocks.
  - **Consultant Engine:** Logic to select 3 specific tasks (Duty, Passion, Energy) based on user history/context.
  - **Checkpoint System:** Handles logic for "Rolling over" or "Dropping" tasks at specific times (Breakfast, Lunch, Dinner).

### Frontend (Flutter)
- **Stack:** Flutter (Latest), Dart.
- **State Management:** **Riverpod Generator** (Strict enforcement).
- **Architecture:** Feature-First Clean Architecture (Domain, Data, Presentation).
- **Network:** Dio with Interceptors (for JWT refresh/Auth).
- **UI/UX:** Material Design 3, customized for a "Gamified/Action" mood.
- **Strategy:**
  - **Core Layer:** Retain/Refactor Auth & Networking.
  - **Feature Layer:** **COMPLETE REWRITE** of UI/Logic to match the "Day 0" screens below.

---

## User Experience & Screens

### 1. Homepage: "Lo Specchio Dinamico" (The Dynamic Mirror)
*Objective: Immediate awareness of the "Here and Now".*

- **Header - Rank Giorno 0:**
  - Visual indicator (Circle/Badge) of the current daily Rank.
  - *Interaction:* Tap to expand -> shows numeric score and comparison (e.g., "Top 10% of your history").
- **Checkpoint Attivo:**
  - Horizontal status bar dividing the day (Breakfast -> Lunch -> Dinner).
  - Visualizes time remaining in the current block.
- **Area "Identità in Azione":**
  - Grid of resolved tasks (Icons only).
  - Represents what the user has "become" today (e.g., Guitar icon, Gym icon).
- **Action Button:**
  - Single, large, central button.
  - *Action:* Opens the "Consulente" (Selection Screen).

### 2. Selection Screen: "Il Consulente" (The Consultant)
*Objective: Removes decision paralysis via a curated shortlist.*

- **The 5 Proposals:**
  - 5 Distinct Cards: **Dovere** (Duty), **Passione** (Passion), **Energia** (Energy), etc.
- **Task Detail:**
  - Explains the "Why" (e.g., "+10 Satisfaction", "Best performed at this hour").
- **Quick Add:**
  - "+" Button to access the full Portfolio if the 3 proposals are rejected.

### 3. Portfolio Screen: "La Biblioteca del Sé" (Library of Self)
*Objective: The database of potential actions.*

- **Organization:** Filter by User Tags (Passion, Duty, Hygiene, etc.).
- **Stats Cards:** Each task shows:
  - Completion count.
  - Average effort.
  - Average satisfaction.
- **Interaction:** Drag & Drop a task into the "Checkpoint Attivo" to "book" it for the current block.

### 4. Checkpoint Mechanism
*Objective: Review and Reset.*

- **Trigger:** Opens at specific times (Breakfast/Lunch/Dinner).
- **Question:** "What happened since the last checkpoint?"
- **Accumulation Management:**
  - Options for uncompleted tasks: **Rilancia** (Move to next block) or **Abbandona** (Reset for today - strictly Day 0).
- **Feedback:** Visual Rank update animation after confirmation.

---

## Development Setup

### Backend
1. `cd backend`
2. `docker-compose up -d`
3. Swagger UI: `http://localhost:8000/docs`

### Frontend
1. `flutter pub get`
2. `flutter run`
3. Use `flutter pub run build_runner watch` for Riverpod/Freezed generation.

## Database Migrations
- Create: `alembic revision --autogenerate -m "message"`
- Apply: `alembic upgrade head`

## Environment
- **Secrets:** Managed via `docker-compose.yml` (Change `SECRET_KEY` for production).
