import logging
from dataclasses import dataclass
from typing import AsyncGenerator

from langchain_core.messages import HumanMessage

from langgraph.types import Command

from app.services.user_service import UserService
from app.services.action_service import ActionService
from app.services.consultant_service import ConsultantService
logger = logging.getLogger(__name__)
HUMAN_MSG_MAX_LENGHT = 5000

class ChatService:
    def __init__(
        self,
        user_service: UserService,
        action_service: ActionService,
        consultant_service: ConsultantService,
        app_graph,
    ):
        self.user_service = user_service
        self.action_service = action_service
        self.consultant_service = consultant_service
        self.app_graph = app_graph

    @dataclass
    class _UserContext:
        rank: int
        portfolio: list[str]
        proposals: list[str]
    
    
    async def _fetch_context(self, user_id) -> _UserContext:
        user = await self.user_service.get_user_by_id(user_id)
        rank = user.rank_score
        
        portfolio_actions = await self.action_service.get_user_portfolio(user_id)
        portfolio_desc = [f"{a.description} ({a.category})" for a in portfolio_actions]
        
        proposals = await self.consultant_service.get_proposals(user_id)
        proposals_desc = [f"{p.description}: {p.category}" for p in proposals]
        
        return self._UserContext(rank=rank, portfolio=portfolio_desc, proposals=proposals_desc)
    
    
    def _return_context_configurable(self, user_id, context: _UserContext):
        return {
            "configurable": {
                "thread_id": str(user_id),
                "user_id": user_id,
                "action_service": self.action_service,
                "rank": context.rank,
                "portfolio": context.portfolio,
                "proposals": context.proposals,
            }}


    async def stream_chat(self, user_id, user_message: str) -> AsyncGenerator[str, None]:
        if len(user_message) > HUMAN_MSG_MAX_LENGHT:
            yield "Il messaggio è troppo lungo. Riducilo a meno di 5000 caratteri."
            return


        input_data = {
            "messages": [
                HumanMessage(content=user_message)
            ]
        }

        context = await self._fetch_context(user_id)
        config = self._return_context_configurable(user_id, context)


        async for event in self.app_graph.astream_events(input_data, config=config, version="v2"):
            if event["event"] == "on_chat_model_stream":
                chunk = event["data"]["chunk"]
                # durante tool_calls chunk.content non è una stringa ma un dict con info sul tool call, quindi controlliamo che sia una stringa prima di streamare
                if chunk.content and isinstance(chunk.content, str):
                    yield chunk.content
        
        state = await self.app_graph.aget_state(config)
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
        context = await self._fetch_context(user_id)
        config = self._return_context_configurable(user_id, context)
        
        # Se l'utente rifiuta, inviamo un feedback immediato via stream prima di riprendere il grafo
        if not confirmed:
            yield "Ricevuto. Annullamento operazione e generazione risposta alternativa...\n\n"

        async for event in self.app_graph.astream_events(
            Command(resume=confirmed),
            config=config,
            version="v2"
        ):
            if event["event"] == "on_chat_model_stream":
                chunk = event["data"]["chunk"]
                if chunk.content and isinstance(chunk.content, str):
                    yield chunk.content
