# Stage 1: Base comune con Python e Poetry installato
FROM python:3.11-slim as base
ENV POETRY_VERSION=1.8.2
RUN pip install "poetry==${POETRY_VERSION}"
RUN poetry config virtualenvs.in-project true
WORKDIR /app
COPY pyproject.toml poetry.lock ./

# Stage 2: Stage di build per la Produzione
# Installa solo le dipendenze di produzione
FROM base as builder
RUN poetry install --no-interaction --no-ansi --only main

# Stage 4: Immagine finale per la Produzione
# È leggera e contiene solo le dipendenze di produzione
FROM python:3.11-slim as production
WORKDIR /app
COPY --from=builder /app/.venv ./.venv
COPY ./app ./app
COPY ./alembic.ini .
COPY ./alembic ./alembic
ENV PATH="/app/.venv/bin:$PATH"
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000", "--proxy-headers", "--forwarded-allow-ips", "*"]