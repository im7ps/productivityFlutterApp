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
            
        self.llm = ChatGoogleGenerativeAI(
            model="gemini-2.5-flash",
            google_api_key=settings.GOOGLE_API_KEY,
            temperature=0.7,
            convert_system_message_to_human=True
        )
        
        self.tools=self._get_tools(None)
        self.llm_with_tools = self.llm.bind_tools(self.tools)

    def _inspect_chain_data(self, data):
        logger.info("--ISPEZIONE DATI CHAIN--")
        logger.info(f"Rank inviato: {data.get('rank')}")
        logger.info(f"Input utente: {data.get('input')}")
        return data

    def _get_tools(self, user_id):
        @tool
        async def start_new_action(description: str, dimension_id: str) -> str:
            """
            Inizia una nuova attività per l'utente.
            Usa questo tool quando l'utente accetta esplicitamente una proposta o dice di voler
            fare qualcosa.
            """
            from app.schemas.action import ActionCreate
            action_in = ActionCreate(
                description=description,
                dimension_id=dimension_id,
                status="IN_PROGRESS"
            )
            try:
                await self.action_service.create_action(user_id, action_in)
                return f"Successo: Attività {description} iniziata correttamente."
            except Exception as e:
                return f"Errore durante la creazione dell'attività: {description}. {str(e)}"
        return [start_new_action]

    def _get_system_prompt(self) -> str:
        return """
    Sei il "Consulente Day 0" di WhatI'veDone. Il tuo obiettivo è eliminare la paralisi decisionale dell'utente.
    La tua filosofia è: "Il miglior momento per fare è ORA. Domani non esiste, oggi è tutto quello che hai."

    CONTESTO UTENTE:
    - Rank Attuale: {rank}
    - Portfolio Attività: {portfolio}
    - Proposte del Giorno: {proposals}

    REGOLE DI COMPORTAMENTO:
    1. Sii pragmatico, anti-paralisi, breve e motivante.
    2. Usa i dati forniti per personalizzare il consiglio (es. se il rank è basso, suggerisci qualcosa di rapido).
    3. Non fare liste lunghe. Punta a una singola azione o una scelta binaria chiara.
    4. Parla in italiano, usa un tono diretto ma incoraggiante.
    5. Se l'utente è indeciso, scegli TU per lui basandoti sulla logica Day 0.
    """

    async def stream_chat(self, user_id, user_message: str) -> AsyncGenerator[str, None]:
        # 1. Recupero Contesto
        user = await self.user_service.get_user_by_id(user_id)
        # TODO: Implement dynamic rank calculation via RankEngine
        rank = 1 # Fallback temporary as User model doesn't have rank_score yet
        
        portfolio_actions = await self.action_service.get_user_portfolio(user_id)
        # logger.info(f"--ISPEZIONE PORTFOLIO actions--\n{portfolio_actions}")
        portfolio_desc = [f"{a.description} ({a.category})" for a in portfolio_actions]
        logger.info(f"--ISPEZIONE PORTFOLIO descriptions--\n{portfolio_desc}")
        
        proposals = await self.consultant_service.get_proposals(user_id)
        proposals_desc = [f"{p.description}: {p.category}" for p in proposals]

        # 2. Preparazione Chain
        prompt = ChatPromptTemplate.from_messages([
            ("system", self._get_system_prompt()),
            ("human", "{input}"),
        ])

        chain = (
            {"rank": lambda x: rank, 
             "portfolio": lambda x: json.dumps(portfolio_desc),
             "proposals": lambda x: json.dumps(proposals_desc),
             "input": RunnablePassthrough()}
            | RunnableLambda(self._inspect_chain_data)
            | prompt
            | self.llm
            | StrOutputParser()
        )

        # 3. Streaming
        async for chunk in chain.astream(user_message):
            yield chunk
