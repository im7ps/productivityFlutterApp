import json
import logging
from typing import AsyncGenerator, List
from pydantic import BaseModel, Field

from langchain_core.messages import HumanMessage
from langchain_core.tools import tool
from langchain_google_genai import ChatGoogleGenerativeAI 
from langchain_core.prompts import ChatPromptTemplate
from langchain_core.output_parsers import StrOutputParser
from langchain_core.runnables import RunnableLambda, RunnablePassthrough

from langgraph.types import Command

from app.services.user_service import UserService
from app.services.action_service import ActionService
from app.services.consultant_service import ConsultantService
from app.core.config import settings
from app.services import chat_graph as chat_graph_module

logger = logging.getLogger(__name__)
HUMAN_MSG_MAX_LENGHT = 5000

class ActionInput(BaseModel):
    description: str = Field(description="La descrizione dell'attività da iniziare")
    dimension_id: str = Field(description="L'ID della dimensione (es. 'passion', 'duties', 'energy')")
    

class ChatService:
    def __init__(
        self,
        user_service: UserService,
        action_service: ActionService,
        consultant_service: ConsultantService,
    ):
        self.user_service = user_service
        self.action_service = action_service
        self.consultant_service = consultant_service
        
        # Inizializzazione LLM con Google Gemini
        if not settings.GOOGLE_API_KEY:
            raise ValueError("GOOGLE_API_KEY is not set in environment variables")


    def _inspect_chain_data(self, data):
        logger.info("--ISPEZIONE DATI CHAIN--")
        logger.info(f"Rank inviato: {data.get('rank')}")
        logger.info(f"Input utente: {data.get('input')}")
        return data


    async def stream_chat(self, user_id, user_message: str) -> AsyncGenerator[str, None]:
        if len(user_message) > HUMAN_MSG_MAX_LENGHT:
            yield "Il messaggio è troppo lungo. Riducilo a meno di 5000 caratteri."
            return
        # Recupero Contesto
        user = await self.user_service.get_user_by_id(user_id)
        rank = user.rank_score
        
        portfolio_actions = await self.action_service.get_user_portfolio(user_id)
        portfolio_desc = [f"{a.description} ({a.category})" for a in portfolio_actions]
        
        proposals = await self.consultant_service.get_proposals(user_id)
        proposals_desc = [f"{p.description}: {p.category}" for p in proposals]

        input_data = {
            "messages": [
                HumanMessage(content=user_message)
            ]
        }
        
        config = {
            "configurable": {
                "thread_id": str(user_id),
                "user_id": user_id,
                "action_service": self.action_service,
                "rank": rank,
                "portfolio": portfolio_desc,
                "proposals": proposals_desc,
            }
        }

        # Inviamo un piccolo segnale di "pensiero" se il messaggio è breve
        if len(user_message) < 100:
             yield "Sto elaborando la tua richiesta...\n\n"

        has_streamed = False
        async for event in chat_graph_module.app_graph.astream_events(input_data, config=config, version="v2"):
            if event["event"] == "on_chat_model_stream":
                chunk = event["data"]["chunk"]
                if chunk.content and isinstance(chunk.content, str):
                    has_streamed = True
                    yield chunk.content
        
        state = await chat_graph_module.app_graph.aget_state(config)
        if state.next:
            for task in state.tasks:
                for interrupt_obj in task.interrupts:
                    tool_calls = (
                        interrupt_obj.value.get("tool_calls", [])
                        if isinstance(interrupt_obj.value, dict)
                        else []
                    )
                    if tool_calls:
                        tool_call = tool_calls[0]
                        # Se non abbiamo streamato nulla (es. il modello ha solo emesso il tool call)
                        # inviamo il messaggio di interrupt chiaramente.
                        yield f"||INTERRUPT||Confermi l'esecuzione di: {tool_call['name']}?"
                        return


    async def resume_chat(self, user_id, confirmed: bool) -> AsyncGenerator[str, None]:
        config = {
            "configurable": {
                "thread_id": str(user_id),
                "user_id": user_id,
                "action_service": self.action_service,
            }
        }
        
        # Se l'utente rifiuta, inviamo un feedback immediato via stream prima di riprendere il grafo
        if not confirmed:
            yield "Ricevuto. Annullamento operazione e generazione risposta alternativa...\n\n"

        async for event in chat_graph_module.app_graph.astream_events(
            Command(resume=confirmed),
            config=config,
            version="v2"
        ):
            if event["event"] == "on_chat_model_stream":
                chunk = event["data"]["chunk"]
                if chunk.content and isinstance(chunk.content, str):
                    yield chunk.content
