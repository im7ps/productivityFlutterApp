# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

"What I've Done" is a full-stack **productivity tracker and emotional compass** app. Backend: FastAPI + PostgreSQL + LangGraph (AI). Frontend: Flutter + Riverpod.

## Commands

### Backend

```bash
# Install dependencies
cd backend && poetry install

# Run dev server
poetry run uvicorn app.main:app --reload

# Run tests (Docker, recommended)
docker compose --profile test up tests

# Run specific test file
poetry run pytest backend/tests/unit/services/test_chat_service.py -v

# Lint & format
ruff check .
ruff format .
mypy .

# Load tests (Locust UI at http://localhost:8089)
docker compose --profile load up load-tests
```

### Frontend

```bash
# Get dependencies
cd frontend && flutter pub get

# Run code generation (Riverpod + Freezed + json_serializable)
dart run build_runner build --delete-conflicting-outputs

# Run tests
flutter test

# Build
flutter build apk   # Android
flutter build web   # Web
```

### Docker (full stack)

```bash
docker compose up           # Start db + backend
docker compose --profile test up tests   # Run test suite
```

## Architecture

### Backend (`backend/app/`)

Layered architecture:

- **`models/`** — SQLModel entities: `User`, `Action`, `DailyLog`, `Dimension`
- **`schemas/`** — Pydantic request/response DTOs
- **`repositories/`** — Data access layer; each entity has its own repo extending `base_repo`
- **`services/`** — Business logic; key services:
  - `chat_graph.py` — LangGraph agentic workflow (state, tool binding, conditional edges)
  - `chat_service.py` — Streaming LLM responses via async generators
  - `consultant_service.py` + `consultant_engine.py` — AI-powered recommendations
- **`api/v1/routers/`** — FastAPI route handlers (auth, users, actions, daily_logs, dimensions, chat, consultant)
- **`core/`** — Cross-cutting: config (Pydantic Settings), security (JWT/bcrypt), exceptions, rate limiting, structlog

**Domain exceptions** are in `core/exceptions.py`: `ResourceNotFound`, `EntityAlreadyExists`, `InvalidCredentials`, `DomainValidationError`.

### Frontend (`frontend/lib/`)

Feature-based clean architecture with Riverpod:

- **`core/`** — Networking (Dio + interceptors), router (GoRouter), storage (SecureStorage + SharedPreferences), theme, localization, constants, errors
- **`features/`** — One directory per feature, each with `data/`, `domain/`, `presentation/` layers:
  - `auth/`, `action/`, `daily_log/`, `dashboard/`, `dimension/`, `chat/`, `consultant/`, `onboarding/`, `account/`, `settings/`

**Code generation is required** for Riverpod providers (`@riverpod` annotation → `.g.dart`) and Freezed models (`@freezed` → `.freezed.dart`). Always run `build_runner` after modifying annotated files.

### AI / LangGraph

The chat feature uses a **LangGraph agentic graph** (`chat_graph.py`) with:
- State persistence via memory saver
- Tools bound to the LLM (Gemini via `langchain-google-genai`)
- Conditional edges routing between tool calls and response generation
- Dynamic system prompt injected per-session context
- LangSmith tracing (optional, configured via env vars)

## Domain Model

| Entity | Key Fields | Relations |
|---|---|---|
| `User` | id (UUID), username, email, rank_score (int) | 1→N Actions, 1→N DailyLogs |
| `Dimension` | global categories (passion, duties, energy, growth) | shared across users |
| `Action` | start_time, end_time, description, category, difficulty (1–5), status (COMPLETED/FAILED/POSTPONED), fulfillment_score (1–5) | N→1 User, N→1 Dimension |
| `DailyLog` | aggregated daily summary | N→1 User |

## Environment Variables

Copy `.env.example` to `.env`. Key variables:

```env
ENVIRONMENT=local          # local | staging | production
POSTGRES_USER / POSTGRES_PASSWORD / POSTGRES_DB
SECRET_KEY / ALGORITHM / ACCESS_TOKEN_EXPIRE_MINUTES
GOOGLE_API_KEY             # Gemini API key
LANGCHAIN_TRACING_V2       # Optional LangSmith tracing
LANGCHAIN_API_KEY / LANGCHAIN_PROJECT
BACKEND_CORS_ORIGINS       # JSON array or comma-separated URLs
```

Production mode enforces non-localhost CORS origins. Local mode auto-permits localhost.

## Testing

- **Integration tests**: `backend/tests/integration/api/` and `integration/repositories/`
- **Unit tests**: `backend/tests/unit/services/` and `unit/test_*.py`
- **Load tests**: `backend/locustfile.py` (Locust)
- Tests use `testcontainers` for real PostgreSQL and `pytest-asyncio` for async routes
- Frontend tests use `mocktail` and `fake_async`
