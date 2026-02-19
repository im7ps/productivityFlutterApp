# Roadmap di Studio: LangChain -> LangGraph

## Lezioni Completate
1. **Analisi del Flusso (Black Box)**: Ispezione dei dati tramite `RunnableLambda` e LangSmith.
2. **Data Integrity**: Risoluzione bug duplicati nel Portfolio (importanza del "Garbage In, Garbage Out").
3. **Tool Definition**: Fondamenti di Pydantic (`BaseModel`, `Field`), Docstrings come prompt e binding degli strumenti all'LLM.
4. **Tool Manual Handling**: Analisi del "caos" dei cicli manuali (invocazione -> verifica `tool_calls` -> ri-invocazione).

## Concetti Chiave Appresi
- **LCEL**: Pipeline lineari vs Grafi ciclici.
- **Pydantic**: Validazione e generazione di JSON Schema per l'IA.
- **Yield**: Streaming dei dati per la UX.

## Prossimi Passi
- **LangGraph 101**: Definizione dello `AgentState`.
- **Nodi e Bordi**: Creazione del primo ciclo automatico Agente-Azione.
- **Persistence**: Uso dei Checkpointer di LangGraph.

---
*Ultimo aggiornamento: Lezione su Tool e Yield completata. Pronto per implementare `AgentState` in `chat_graph.py`.*
