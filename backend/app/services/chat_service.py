import json
from typing import AsyncGenerator, List
from langchain_google_genai import ChatGoogleGenerativeAI 
from langchain_core.prompts import ChatPromptTemplate
from langchain_core.output_parsers import StrOutputParser
from langchain_core.runnables import RunnablePassthrough

from app.services.user_service import UserService
from app.services.action_service import ActionService
from app.services.consultant_service import ConsultantService
from app.core.config import settings

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
        rank = 0 # Fallback temporary as User model doesn't have rank_score yet
        
        portfolio_actions = await self.action_service.get_user_actions(user_id)
        portfolio_desc = [f"{a.description} ({a.category})" for a in portfolio_actions]
        
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
            | prompt
            | self.llm
            | StrOutputParser()
        )

        # 3. Streaming
        async for chunk in chain.astream(user_message):
            yield chunk
