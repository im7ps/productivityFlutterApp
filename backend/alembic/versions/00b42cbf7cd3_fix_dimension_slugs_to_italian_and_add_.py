"""fix dimension slugs to italian and add missing ones

Revision ID: 00b42cbf7cd3
Revises: 487c0f613212
Create Date: 2026-02-28 22:45:00.000000

"""
from typing import Sequence, Union
from alembic import op
import sqlalchemy as sa

# revision identifiers, used by Alembic.
revision: str = '00b42cbf7cd3'
down_revision: Union[str, Sequence[str], None] = '487c0f613212'
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    # 1. Temporarily rename existing names to avoid unique constraint violations
    op.execute("UPDATE dimension SET name = name || '_old'")

    # 2. Add/Update all Italian dimensions
    dimensions_data = [
        {"id": "dovere", "name": "Dovere", "description": "Obblighi, lavoro e responsabilità"},
        {"id": "passione", "name": "Passione", "description": "Hobby, interessi e creatività"},
        {"id": "energia", "name": "Energia", "description": "Salute fisica e vitalità"},
        {"id": "relazioni", "name": "Relazioni", "description": "Famiglia, amici e connessione"},
        {"id": "anima", "name": "Anima", "description": "Crescita spirituale e senso profondo"},
        {"id": "chiarezza", "name": "Chiarezza", "description": "Mente focalizzata e apprendimento"},
    ]
    
    for dim in dimensions_data:
        sql = f"""
        INSERT INTO dimension (id, name, description) 
        VALUES ('{dim['id']}', '{dim['name']}', '{dim['description'].replace("'", "''")}')
        ON CONFLICT (id) DO UPDATE SET 
            name = EXCLUDED.name,
            description = EXCLUDED.description;
        """
        op.execute(sql)

    # 3. Map existing actions from old slugs to new Italian ones
    mappings = {
        "energy": "energia",
        "relationships": "relazioni",
        "soul": "anima",
        "clarity": "chiarezza"
    }
    
    for old, new in mappings.items():
        op.execute(f"UPDATE action SET dimension_id = '{new}' WHERE dimension_id = '{old}'")
        
    # 4. Clean up old English dimensions
    for old in mappings.keys():
        op.execute(f"DELETE FROM dimension WHERE id = '{old}'")


def downgrade() -> None:
    pass
