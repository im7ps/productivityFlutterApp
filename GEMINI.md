# GEMINI.md

## Project Overview

This is a Flutter application with a Python backend. The project is designed to be a productivity tracker.

### Frontend (Flutter)

The frontend is a Flutter application. The code is located in the `lib` directory. At the moment, the frontend is the default Flutter counter app.

### Backend (Python)

The backend is a Python FastAPI application. The code is located in the `backend` directory.

The backend provides the following features:

*   User authentication (signup and login)
*   Category management (create and list)

The backend uses the following technologies:

*   **FastAPI:** A modern, fast (high-performance) web framework for building APIs with Python 3.7+ based on standard Python type hints.
*   **SQLModel:** A library for interacting with SQL databases from Python code, with Python objects.
*   **Alembic:** A lightweight database migration tool for usage with the SQLAlchemy Database Toolkit for Python.
*   **PostgreSQL:** A powerful, open source object-relational database system.
*   **Docker:** The backend is designed to be run in a Docker container.

## Building and Running

### Backend

To run the backend, you need to have Docker and Docker Compose installed.

1.  Navigate to the `backend` directory.
2.  Run the following command:

```bash
docker-compose up -d
```

The backend will be available at `http://localhost:8000`.

### Frontend

To run the frontend, you need to have Flutter installed.

1.  Navigate to the root directory of the project.
2.  Run the following command:

```bash
flutter run
```

## Development Conventions

### Backend

The backend code follows the standard FastAPI project structure. It uses a `.env` file for environment variables. A `.env.example` file is provided to show the required variables.

### Frontend

The frontend code follows the standard Flutter project structure.

## Database Migrations

The project uses Alembic for database migrations. To create a new migration, run the following command in the `backend` directory:

```bash
alembic revision --autogenerate -m "Your migration message"
```

To apply the migrations, run the following command:

```bash
alembic upgrade head
```
## Authentication

The backend uses JWT for authentication. The `auth_utils.py` file contains the password hashing and JWT creation logic. The secret key is hardcoded in the `auth_utils.py` file. This should be moved to an environment variable in a production environment.