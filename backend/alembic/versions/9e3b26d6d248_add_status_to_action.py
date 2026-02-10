"""add status to action

Revision ID: 9e3b26d6d248
Revises: 4a9e26f97b5c
Create Date: 2026-02-10 22:32:08.793786

"""
from typing import Sequence, Union

from alembic import op
import sqlalchemy as sa
import sqlmodel


# revision identifiers, used by Alembic.
revision: str = '9e3b26d6d248'
down_revision: Union[str, Sequence[str], None] = '4a9e26f97b5c'
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    """Upgrade schema."""
    # 1. Aggiungi la colonna come nullable
    op.add_column('action', sa.Column('status', sqlmodel.sql.sqltypes.AutoString(), nullable=True))
    
    # 2. Imposta un valore di default per le righe esistenti
    op.execute("UPDATE action SET status = 'COMPLETED'")
    
    # 3. Rendi la colonna NOT NULL
    op.alter_column('action', 'status', nullable=False)
    
    # 4. Crea l'indice
    op.create_index(op.f('ix_action_status'), 'action', ['status'], unique=False)


def downgrade() -> None:
    """Downgrade schema."""
    op.drop_index(op.f('ix_action_status'), table_name='action')
    op.drop_column('action', 'status')
