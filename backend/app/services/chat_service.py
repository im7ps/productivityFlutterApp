import json
import logging
from typing import AsyncGenerator, List
from pydantic import BaseModel, Field
from langchain_core.messages import HumanMessage, ToolMessage, AIMessage
from langchain_core.tools import tool
from langchain_google_genai import ChatGoogleGenerativeAI 
from langchain_core.prompts import ChatPromptTemplate
from langchain_core.output_parsers import StrOutputParser
from langchain_core.runnables import RunnableLambda, RunnablePassthrough

from app.services.user_service import UserService
from app.services.action_service import ActionService
from app.services.consultant_service import ConsultantService
from app.core.config import settings
from app.services.chat_graph import app_graph

logger = logging.getLogger(__name__)

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
        # 1. Recupero Contesto
        user = await self.user_service.get_user_by_id(user_id)
        # TODO: Implement dynamic rank calculation via RankEngine
        rank = user.rank_score
        
        portfolio_actions = await self.action_service.get_user_portfolio(user_id)
        # logger.info(f"--ISPEZIONE PORTFOLIO actions--\n{portfolio_actions}")
        portfolio_desc = [f"{a.description} ({a.category})" for a in portfolio_actions]
        # logger.info(f"--ISPEZIONE PORTFOLIO descriptions--\n{portfolio_desc}")
        
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


        async for event in app_graph.astream_events(input_data, config=config, version="v2"):
            if event["event"] == "on_chat_model_stream":
                chunk = event["data"]["chunk"]
                if chunk.content:
                    yield chunk.content

