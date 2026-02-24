# backend/app/services/chat_graph.py

from typing import Annotated, TypedDict, Literal
import logging

from langgraph.graph import StateGraph, START, END
from langgraph.graph.message import add_messages
from langgraph.prebuilt import ToolNode
from langgraph.types import interrupt

from langchain_core.messages import HumanMessage, BaseMessage, SystemMessage, AIMessage
from langchain_google_genai import ChatGoogleGenerativeAI
from langchain_core.tools import tool
from langchain_core.runnables import RunnableConfig

from app.core.config import settings

# Inizializza il logger
logger = logging.getLogger(__name__)

# 1. DEFINIZIONE DELLO STATO (La "lavagna" condivisa tra i nodi)
class GraphState(TypedDict):
    # Annotated + add_messages permette di accumulare i messaggi nella cronologia
    messages: Annotated[list[BaseMessage], add_messages]


SYSTEM_PROMPT_TEMPLATE = """
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


@tool
async def get_user_portfolio(config: RunnableConfig):
    """Restituisce la lista delle azioni nel portfolio dell'utente.
    Usa questo tool per sapere cosa l'utente ha fatto o vuole fare in futuro."""
    
    user_id = config["configurable"].get("user_id")
    action_service = config["configurable"].get("action_service")
    
    if not action_service or not user_id:
        raise ValueError("action_service o user_id non disponibili nel config")
    
    actions = await action_service.get_user_portfolio(user_id)
    if not actions:
        return "L'utente non ha azioni nel suo portfolio"
    return [f"{a.description} (Categoria: {a.category})" for a in actions]

@tool
async def start_new_action(description: str, dimension_id: str, config: RunnableConfig):
    """Inizia una nuova task per l'utente. 
    DIMENSION_ID validi: 'passion', 'duties', 'energy'.
    Usa questo tool SOLO quando l'utente accetta esplicitamente una task o dice chiaramente di voler fare qualcosa
    """
    user_id = config["configurable"].get("user_id")
    action_service = config["configurable"].get("action_service")
    
    from app.schemas.action import ActionCreate
    
    action_in = ActionCreate(
        description=description,
        dimension_id=dimension_id,
        status="IN_PROGRESS"
    )
    
    try:
        await action_service.create_action(user_id, action_in)
        return f"SUCCESSO: L'attività '{description}' è stata avviata correttamente."
    except Exception as e:
        return f"ERRORE: Impossibile avviare la task. Dettaglio: {str(e)}"

def build_tools() -> list:
    tools = [get_user_portfolio, start_new_action]
    return tools


def build_tool_node() -> ToolNode:
    # Il ToolNode è un componente pre-costruito che esegue i tool chiamati dall'LLM
    tools = build_tools()
    return ToolNode(tools, handle_tool_errors=True)


def fetch_llm() -> ChatGoogleGenerativeAI:
    # 3. CONFIGURAZIONE DELL'LLM (Gemini)
    llm = ChatGoogleGenerativeAI(
        model="gemini-2.5-flash",
        google_api_key=settings.GOOGLE_API_KEY,
        temperature=0.1,
        convert_system_message_to_human=True
    )
    return llm


def fetch_llm_with_tools() -> ChatGoogleGenerativeAI:
    llm = fetch_llm()
    tools = build_tools()
    return llm.bind_tools(tools)


# TODO: implementare una guardia per evitare che in un turno ci siano conversazioni da miliardi di token
def trim_to_last_n_turns(messages: list[BaseMessage], n: int = 5) -> list[BaseMessage]:
    """Mantiene gli ultimi N turni completi. Un turno = HumanMessage + tutto ciò che segue."""
    turns = []
    current_turn = []
    for msg in messages:
        if isinstance(msg, HumanMessage) and current_turn:
            turns.append(current_turn)
            current_turn = [msg]
        else:
            current_turn.append(msg)
    if current_turn:
        turns.append(current_turn)
    return [msg for turn in turns[-n:] for msg in turn]


def route_tools(state: GraphState) -> Literal["tools", "__end__"]:
    """
    Funzione di routing (Bivio):
    Controlla se l'ultimo messaggio dell'IA contiene richieste di tool.
    """
    msg = state["messages"][-1]
    tool_calls = getattr(msg, "tool_calls", [])
    if tool_calls:
        logger.info(f"Routing: Tool calls rilevati ({len(tool_calls)}). Vado a 'tools'.")
        return "tools"
    
    logger.info("Routing: Nessun tool call. Fine conversazione.")
    return "__end__"


def build_workflow(graphState: GraphState, chatbot_func) -> StateGraph:
    tool_node = build_tool_node()

    # 5. COSTRUZIONE DEL WORKFLOW (Il Grafo)
    workflow = StateGraph(graphState)

    # Aggiungiamo i nodi al grafo
    workflow.add_node("agent", chatbot_func)
    workflow.add_node("tools", tool_node)

    # Definiamo il punto di inizio
    workflow.add_edge(START, "agent")

    # Aggiungiamo il bivio condizionale dopo il nodo 'agent'
    workflow.add_conditional_edges(
        "agent",
        route_tools,
    )

    # Dopo l'esecuzione dei tool, il controllo torna sempre all'agente per rispondere
    workflow.add_edge("tools", "agent")
    return workflow

def compile_graph(checkpointer):
    llm = fetch_llm()
    llm_with_tools = fetch_llm_with_tools()

    async def chatbot(state: GraphState, config: RunnableConfig):
        """Nodo principale: invoca l'LLM con la cronologia dei messaggi in streaming."""
        
        rank = config["configurable"].get("rank", 0)
        portfolio = config["configurable"].get("portfolio", [])
        proposals = config["configurable"].get("proposals", [])


        system_message = SystemMessage(content=SYSTEM_PROMPT_TEMPLATE.format(
            rank=rank,
            portfolio=portfolio,
            proposals=proposals,
        ))

        trimmed = trim_to_last_n_turns(state["messages"], 5)
        full_context = [system_message] + trimmed
        
        # 1. Chiamata iniziale con astream per supportare lo streaming diretto
        final_message = None
        async for chunk in llm_with_tools.astream(full_context, config=config):
            if final_message is None:
                final_message = chunk
            else:
                final_message += chunk
        
        if final_message.tool_calls:
            # Sospensione del grafo per intervento umano (interrupt)
            confirmed = interrupt({"tool_calls": final_message.tool_calls})
            
            if not confirmed:
                logger.info("Tool REJECTED. Generazione risposta di rifiuto in streaming...")
                # 2. Se rifiutato, generiamo una nuova risposta (senza tools) via astream
                rejection_message = None
                async for chunk in llm.astream(full_context, config=config):
                    if rejection_message is None:
                        rejection_message = chunk
                    else:
                        rejection_message += chunk
                return {"messages": [rejection_message]}
                
            logger.info("Tool ACCEPTED. Procedo al nodo tools.")
        
        # Se non ci sono tool calls o se sono state accettate, restituiamo il messaggio accumulato
        return {"messages": [final_message]}

    workflow = build_workflow(GraphState, chatbot)
    app_graph = workflow.compile(checkpointer=checkpointer)
    return app_graph
