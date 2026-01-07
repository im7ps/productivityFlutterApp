from sqlmodel import SQLModel
from pydantic import ConfigDict

class TunableBaseModel(SQLModel):
    model_config = ConfigDict(str_strip_whitespace=True, extra="forbid")
