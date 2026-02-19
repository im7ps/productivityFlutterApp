# backend/app/services/chat_graph.py

from typing import Annotated, TypedDict, List
from langgraph.graph.message import add_messages

class AgentState(TypedDict):
    # 'messages' è speciale: add_messages permette di appendere i messaggi 
    # invece di sovrascriverli (fondamentale per la memoria!)
    messages: Annotated[List, add_messages]

    # Dati di contesto del nostro utente
    rank: int
    portfolio: List[str]
    proposals: List[str]

    # Una variabile per decidere se l'utente ha accettato o no
    user_satisfied: bool
    user_id: str