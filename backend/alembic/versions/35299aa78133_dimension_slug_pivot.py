"""dimension_slug_pivot

Revision ID: 35299aa78133
Revises: 29b91b1312eb
Create Date: 2026-02-07 23:20:12.011411

"""
from typing import Sequence, Union

from alembic import op
import sqlalchemy as sa
import sqlmodel


# revision identifiers, used by Alembic.
revision: str = '35299aa78133'
down_revision: Union[str, Sequence[str], None] = '29b91b1312eb'
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    """Upgrade schema."""
    # 1. Pulizia tabelle per evitare conflitti di tipo durante il pivot
    op.execute("DELETE FROM action")
    op.execute("DELETE FROM dimension")

    # 2. Rimuoviamo i vincoli esistenti
    op.drop_constraint('action_dimension_id_fkey', 'action', type_='foreignkey')
    
    # 3. Pivot della tabella Dimension (PK da UUID a String/Slug)
    op.drop_index('ix_dimension_name', table_name='dimension')
    op.drop_table('dimension')
    
    op.create_table('dimension',
        sa.Column('id', sa.String(), nullable=False),
        sa.Column('name', sa.String(), nullable=False),
        sa.Column('description', sa.String(), nullable=True),
        sa.PrimaryKeyConstraint('id')
    )
    op.create_index(op.f('ix_dimension_id'), 'dimension', ['id'], unique=False)
    op.create_index(op.f('ix_dimension_name'), 'dimension', ['name'], unique=True)

    # 4. Aggiornamento tabella Action (FK da UUID a String)
    op.alter_column('action', 'dimension_id',
               existing_type=sa.UUID(),
               type_=sa.String(),
               nullable=False)
               
    # 5. Ripristino Vincolo FK
    op.create_foreign_key('action_dimension_id_fkey', 'action', 'dimension', ['dimension_id'], ['id'])

    # 6. SEED DATA con SLUG
    dimensions_data = [
        {"id": "energy", "name": "Energia", "description": "Il tempio fisico e la vitalità"},
        {"id": "clarity", "name": "Chiarezza", "description": "La mente focalizzata e l''apprendimento"},
        {"id": "relationships", "name": "Relazioni", "description": "La tribù, il cuore e la connessione"},
        {"id": "soul", "name": "Anima", "description": "Il perché profondo e lo spirito"},
    ]
    for dim in dimensions_data:
        op.execute(
            sa.text(f"INSERT INTO dimension (id, name, description) VALUES ('{dim['id']}', '{dim['name']}', '{dim['description']}')")
        )


def downgrade() -> None:
    """Downgrade schema (Non raccomandato in questa fase di pivot distruttivo)"""
    pass
