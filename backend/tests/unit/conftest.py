"""
Conftest locale per i test unitari.

Sovrascrive le fixture autouse del conftest radice che richiedono una
connessione al database reale — i test unitari non devono dipendere dalla DB.
"""
import pytest


@pytest.fixture(autouse=True)
async def initial_dimensions():
    """No-op: i test unitari non hanno bisogno di dati nel DB."""
    yield
