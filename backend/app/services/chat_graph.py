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
Sei il "Consulente Day 0" di WhatI'veDone. Il tuo obiettivo è eliminare la paralisi decisionale dell'utente e aiutarlo a definire le sue azioni per la giornata.

La tua filosofia è: "Ogni giorno è il Giorno 0. Quello che conta è cosa decidi di fare OGGI."

CONTESTO UTENTE:
- Rank Attuale: {rank}
- Portfolio Attività: {portfolio}
- Proposte del Giorno: {proposals}

LOGICA DI CREAZIONE TASK (Slot Filling):
Prima di aggiungere una nuova task con il tool `start_new_action`, devi assicurarti di avere queste informazioni. Se mancano, chiedile:
1. **Cosa**: Una descrizione chiara (es. "Studiare Flutter").
2. **Quanto**: Una durata stimata in minuti (proponila tu se l'utente non la specifica).
3. **Dimensione**: Scegli tra 'dovere', 'passione', 'energia', 'relazioni', 'anima'.

REGOLE DI COMPORTAMENTO:
1. Sii pragmatico, breve e motivante.
2. Quando l'utente esprime un desiderio, aiutalo a trasformarlo in una task per la giornata. Non forzare l'idea che debba iniziare "in questo istante", ma che la task sia pianificata per oggi.
3. Non chiamare `start_new_action` finché non hai i dettagli necessari.
4. Se l'utente rifiuta una conferma del tool, chiedi subito cosa preferisce cambiare (durata, descrizione o dimensione).
5. Parla in italiano, usa un tono diretto.

QUANDO CREI UNA TASK:
- Sincronizza sempre la `category` con il `dimension_id` (capitalizzato).
- Stima un `fulfillment_score` (1-5) realistico se non specificato.
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
async def start_new_action(
    description: str, 
    dimension_id: str, 
    fulfillment_score: int = 3,
    duration_minutes: int | None = None,
    config: RunnableConfig = None
):
    """Inizia una nuova task per l'utente. 
    DIMENSION_ID validi: 'dovere', 'passione', 'energia', 'relazioni', 'anima'.
    Usa questo tool SOLO quando l'utente accetta esplicitamente una task o dice chiaramente di voler fare qualcosa.
    
    Args:
        description: Breve descrizione dell'attività.
        dimension_id: Lo slug della dimensione (es. 'passione').
        fulfillment_score: Valore da 1 a 5 dell'appagamento previsto (default 3).
        duration_minutes: Durata prevista in minuti (opzionale).
    """
    user_id = config["configurable"].get("user_id")
    action_service = config["configurable"].get("action_service")
    
    # Normalizzazione e Mapping delle Dimensioni (per gestire slug vecchi o in inglese)
    mapping = {
        "energy": "energia",
        "soul": "anima",
        "relationships": "relazioni",
        "clarity": "chiarezza",
        "duties": "dovere",
        "passions": "passione",
        "work": "dovere",
        "health": "energia"
    }
    
    normalized_id = dimension_id.lower().strip()
    if normalized_id in mapping:
        print(f"DEBUG: start_new_action - Mapping '{normalized_id}' to '{mapping[normalized_id]}'")
        normalized_id = mapping[normalized_id]
    
    print(f"DEBUG: start_new_action tool triggered - Description: '{description}', Dimension: '{normalized_id}' (original: '{dimension_id}'), Duration: {duration_minutes}")
    
    if not action_service or not user_id:
        print("DEBUG: start_new_action tool FAILED - missing service or user_id")
        return "ERRORE: Servizio non disponibile."
        
    from app.schemas.action import ActionCreate
    
    action_in = ActionCreate(
        description=description,
        dimension_id=normalized_id,
        category=normalized_id.capitalize(),
        fulfillment_score=fulfillment_score,
        duration_minutes=duration_minutes,
        status="IN_PROGRESS"
    )
    
    try:
        print(f"DEBUG: calling action_service.create_action for user {user_id}")
        await action_service.create_action(user_id, action_in)
        print(f"DEBUG: action_service.create_action SUCCESS for '{description}'")
        return f"SUCCESSO: L'attività '{description}' è stata avviata correttamente."
    except Exception as e:
        print(f"DEBUG: action_service.create_action EXCEPTION: {str(e)}")
        return f"ERRORE: Impossibile avviare la task. Dettaglio: {str(e)}"

@tool
async def delete_action(description_query: str, config: RunnableConfig):
    """Cancella una task dell'utente basandosi sulla descrizione.
    Usa questo tool quando l'utente vuole annullare, rimuovere o cancellare un'attività specifica.
    
    Args:
        description_query: Parola chiave o descrizione della task da cancellare.
    """
    user_id = config["configurable"].get("user_id")
    action_service = config["configurable"].get("action_service")
    
    print(f"DEBUG: delete_action tool triggered - Query: '{description_query}'")
    
    if not action_service or not user_id:
        print("DEBUG: delete_action tool FAILED - missing service or user_id")
        return "ERRORE: Servizio non disponibile."
    
    try:
        # 1. Recuperiamo TUTTE le azioni uniche (Portfolio) per un match più preciso
        actions = await action_service.get_user_portfolio(user_id)
        
        # 2. Se non troviamo nulla nel portfolio, proviamo le azioni recenti (incluse quelle IN_PROGRESS)
        if not any(description_query.lower() in (a.description or "").lower() for a in actions):
            recent = await action_service.get_user_actions(user_id, limit=50)
            actions.extend(recent)

        print(f"DEBUG: delete_action - searching in {len(actions)} total action templates")
        
        # Cerchiamo un match (case insensitive)
        target_action = None
        for a in actions:
            if description_query.lower() in (a.description or "").lower():
                target_action = a
                break
        
        if not target_action:
            print(f"DEBUG: delete_action - NO MATCH found for query '{description_query}'")
            return f"ERRORE: Non ho trovato nessuna attività che corrisponde a '{description_query}'."
            
        print(f"DEBUG: delete_action - MATCH FOUND: '{target_action.description}' (ID: {target_action.id}). Deleting...")
        success = await action_service.delete_action(user_id, target_action.id)
        if success:
            print(f"DEBUG: delete_action SUCCESS for '{target_action.description}'")
            return f"SUCCESSO: L'attività '{target_action.description}' è stata rimossa."
        else:
            print(f"DEBUG: delete_action FAILED for ID: {target_action.id}")
            return "ERRORE: Impossibile cancellare l'attività."
            
    except Exception as e:
        print(f"DEBUG: delete_action EXCEPTION: {str(e)}")
        return f"ERRORE: {str(e)}"

def build_tools() -> list:
    tools = [get_user_portfolio, start_new_action, delete_action]
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
    )
    return llm


def fetch_llm_with_tools() -> ChatGoogleGenerativeAI:
    llm = fetch_llm()
    tools = build_tools()
    return llm.bind_tools(tools)


# TODO: implementare una guardia per evitare che in un turno ci siano conversazioni da miliardi di token
def trim_to_last_n_turns(messages: list[BaseMessage], n: int = 10) -> list[BaseMessage]:
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

        trimmed = trim_to_last_n_turns(state["messages"], 10)
        full_context = [system_message] + trimmed
        
        # 1. Chiamata iniziale con astream per supportare lo streaming diretto
        final_message = None
        async for chunk in llm_with_tools.astream(full_context, config=config):
            if final_message is None:
                final_message = chunk
            else:
                final_message += chunk
        
        if final_message.tool_calls:
            # Sospensione del grafo per intervento umano (interrupt) solo per tool di scrittura
            modifying_tools = ["start_new_action", "delete_action"]
            needs_confirmation = any(tc["name"] in modifying_tools for tc in final_message.tool_calls)
            
            if needs_confirmation:
                confirmed = interrupt({"tool_calls": final_message.tool_calls})
                
                if not confirmed:
                    logger.info("Tool REJECTED. Generazione risposta di rifiuto in streaming...")
                    rejection_message = None
                    async for chunk in llm.astream(full_context, config=config):
                        if rejection_message is None:
                            rejection_message = chunk
                        else:
                            rejection_message += chunk
                    return {"messages": [rejection_message]}
                    
                logger.info("Tool ACCEPTED. Procedo al nodo tools.")
            else:
                logger.info("Read-only tool detected. Skipping interrupt.")
        
        # Se non ci sono tool calls o se sono state accettate, restituiamo il messaggio accumulato
        return {"messages": [final_message]}

    workflow = build_workflow(GraphState, chatbot)
    app_graph = workflow.compile(checkpointer=checkpointer)
    return app_graph
