"""add_day0_fields_to_action

Revision ID: 4a9e26f97b5c
Revises: 35299aa78133
Create Date: 2026-02-10 19:53:15.910270

"""
from typing import Sequence, Union

from alembic import op
import sqlalchemy as sa
import sqlmodel


# revision identifiers, used by Alembic.
revision: str = '4a9e26f97b5c'
down_revision: Union[str, Sequence[str], None] = '35299aa78133'
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    """Upgrade schema."""
    # 1. Aggiungi come nullable
    op.add_column('action', sa.Column('category', sqlmodel.sql.sqltypes.AutoString(), nullable=True))
    op.add_column('action', sa.Column('difficulty', sa.Integer(), nullable=True))
    
    # 2. Popola dati esistenti
    op.execute("UPDATE action SET category = 'Dovere' WHERE category IS NULL")
    op.execute("UPDATE action SET difficulty = 3 WHERE difficulty IS NULL")
    
    # 3. Imposta come NOT NULL
    op.alter_column('action', 'category', nullable=False)
    op.alter_column('action', 'difficulty', nullable=False)
    
    op.create_index(op.f('ix_action_category'), 'action', ['category'], unique=False)


def downgrade() -> None:
    """Downgrade schema."""
    op.drop_index(op.f('ix_action_category'), table_name='action')
    op.drop_column('action', 'difficulty')
    op.drop_column('action', 'category')
