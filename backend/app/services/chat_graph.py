# backend/app/services/chat_graph.py

from typing import Annotated, TypedDict, Literal
from langgraph.graph import StateGraph, START, END
from langgraph.graph.message import add_messages
from langgraph.prebuilt import ToolNode
from langchain_core.messages import BaseMessage
from langchain_google_genai import ChatGoogleGenerativeAI
from langchain_core.tools import tool
from app.core.config import settings

# 1. DEFINIZIONE DELLO STATO (La "lavagna" condivisa tra i nodi)
class GraphState(TypedDict):
    # Annotated + add_messages permette di accumulare i messaggi nella cronologia
    messages: Annotated[list[BaseMessage], add_messages]

# 2. DEFINIZIONE DEI TOOLS (Azioni eseguibili dall'LLM)
@tool
def get_user_portfolio():
    """Restituisce la lista delle azioni nel portfolio dell'utente."""
    # In una versione reale, qui chiameremmo ActionService
    return ["Allenamento Gym", "Meditazione", "Studio LangGraph", "Lettura Libro"]

tools = [get_user_portfolio]
# Il ToolNode è un componente pre-costruito che esegue i tool chiamati dall'LLM
tool_node = ToolNode(tools)

# 3. CONFIGURAZIONE DELL'LLM (Gemini)
llm = ChatGoogleGenerativeAI(
    model="gemini-2.5-flash",
    google_api_key=settings.GOOGLE_API_KEY,
    temperature=0.7,
    convert_system_message_to_human=True
)

# Colleghiamo i tool all'LLM così che sappia di poterli usare
llm_with_tools = llm.bind_tools(tools)

# 4. DEFINIZIONE DEI NODI (Le funzioni di lavoro)
def chatbot(state: GraphState):
    """Nodo principale: invoca l'LLM con la cronologia dei messaggi."""
    response = llm_with_tools.invoke(state["messages"])
    # Restituisce il nuovo messaggio che verrà aggiunto allo stato via 'add_messages'
    return {"messages": [response]}

def route_tools(state: GraphState) -> Literal["tools", "__end__"]:
    """
    Funzione di routing (Bivio):
    Controlla se l'ultimo messaggio dell'IA contiene richieste di tool.
    """
    msg = state["messages"][-1]
    if msg.tool_calls:
        return "tools"
    # Se non ci sono tool da chiamare, termina la conversazione
    return "__end__"

# 5. COSTRUZIONE DEL WORKFLOW (Il Grafo)
workflow = StateGraph(GraphState)

# Aggiungiamo i nodi al grafo
workflow.add_node("agent", chatbot)
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

# 6. COMPILAZIONE
# Trasforma il diagramma in un'applicazione eseguibile
app_graph = workflow.compile()
