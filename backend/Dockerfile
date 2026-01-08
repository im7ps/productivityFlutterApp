# Stage 1: Base comune con Python e Poetry installato
FROM python:3.11-slim as base
ENV POETRY_VERSION=1.8.2
ENV PYTHONUNBUFFERED=1
RUN pip install "poetry==${POETRY_VERSION}"
RUN poetry config virtualenvs.in-project true
WORKDIR /app
COPY pyproject.toml poetry.lock ./

# Stage 2a: Dependencies per Sviluppo/Test (include dev group)
FROM base as dev-deps
RUN poetry install --no-interaction --no-ansi

# Stage 2b: Dependencies per Produzione (solo main)
FROM base as prod-deps
RUN poetry install --no-interaction --no-ansi --only main

# Stage 3: Immagine per Sviluppo/Test
FROM python:3.11-slim as development
WORKDIR /app
COPY --from=dev-deps /app/.venv ./.venv
COPY . .
ENV PATH="/app/.venv/bin:$PATH"
# Comando default (può essere sovrascritto da docker-compose)
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000", "--reload"]

# Stage 4: Immagine finale per la Produzione
FROM python:3.11-slim as production
WORKDIR /app
COPY --from=prod-deps /app/.venv ./.venv
COPY ./app ./app
COPY ./alembic.ini .
COPY ./alembic ./alembic
ENV PATH="/app/.venv/bin:$PATH"
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000", "--proxy-headers", "--forwarded-allow-ips", "*"]