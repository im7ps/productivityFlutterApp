import pytest
from unittest.mock import AsyncMock, MagicMock
from langchain_core.messages import AIMessageChunk

from app.services.chat_service import ChatService


# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------

def _make_deps():
    """Costruisce i mock delle dipendenze con dati di contesto realistici."""
    user_svc = AsyncMock()
    action_svc = AsyncMock()
    consultant_svc = AsyncMock()

    mock_user = MagicMock()
    mock_user.rank_score = 42
    user_svc.get_user_by_id.return_value = mock_user

    mock_action = MagicMock()
    mock_action.description = "Meditazione"
    mock_action.category = "Salute"
    action_svc.get_user_portfolio.return_value = [mock_action]

    mock_proposal = MagicMock()
    mock_proposal.description = "Allenamento"
    mock_proposal.category = "Fitness"
    consultant_svc.get_proposals.return_value = [mock_proposal]

    return user_svc, action_svc, consultant_svc


def _make_service(app_graph):
    user_svc, action_svc, consultant_svc = _make_deps()
    service = ChatService(
        user_service=user_svc,
        action_service=action_svc,
        consultant_service=consultant_svc,
        app_graph=app_graph,
    )
    return service, user_svc, action_svc, consultant_svc


def _stream_event(content: str):
    """Crea un evento on_chat_model_stream con il contenuto dato."""
    return {
        "event": "on_chat_model_stream",
        "data": {"chunk": AIMessageChunk(content=content)},
    }


def _no_interrupt_state():
    state = MagicMock()
    state.next = []
    return state


# ---------------------------------------------------------------------------
# stream_chat
# ---------------------------------------------------------------------------

@pytest.mark.asyncio
async def test_stream_chat_recupera_contesto_e_streama_chunks():
    """
    Verifica che stream_chat:
    - recuperi rank, portfolio e proposals dai servizi corretti
    - streami il testo dell'LLM chunk per chunk
    """
    mock_graph = MagicMock()

    async def fake_astream_events(*args, **kwargs):
        yield _stream_event("Risposta ")
        yield _stream_event("mockata.")

    mock_graph.astream_events = fake_astream_events
    mock_graph.aget_state = AsyncMock(return_value=_no_interrupt_state())

    service, user_svc, action_svc, consultant_svc = _make_service(mock_graph)

    chunks = []
    async for chunk in service.stream_chat(user_id="test-uuid", user_message="Cosa dovrei fare?"):
        chunks.append(chunk)

    assert "".join(chunks) == "Risposta mockata."
    user_svc.get_user_by_id.assert_called_once_with("test-uuid")
    action_svc.get_user_portfolio.assert_called_once_with("test-uuid")
    consultant_svc.get_proposals.assert_called_once_with("test-uuid")


@pytest.mark.asyncio
async def test_stream_chat_emette_interrupt_quando_tool_in_pausa():
    """
    Verifica che stream_chat emetta il token ||INTERRUPT|| con il nome del tool
    quando il grafo è sospeso in attesa di conferma HITL.
    """
    mock_graph = MagicMock()

    async def fake_astream_events(*args, **kwargs):
        # Durante un tool call l'LLM non emette content testuale
        yield _stream_event("")

    mock_interrupt = MagicMock()
    mock_interrupt.value = {"tool_calls": [{"name": "start_new_action"}]}
    mock_task = MagicMock()
    mock_task.interrupts = [mock_interrupt]

    mock_state = MagicMock()
    mock_state.next = ["tools"]
    mock_state.tasks = [mock_task]

    mock_graph.astream_events = fake_astream_events
    mock_graph.aget_state = AsyncMock(return_value=mock_state)

    service, *_ = _make_service(mock_graph)

    chunks = []
    async for chunk in service.stream_chat(user_id="test-uuid", user_message="Avvia meditazione"):
        chunks.append(chunk)

    full = "".join(chunks)
    assert "||INTERRUPT||" in full
    assert "start_new_action" in full


@pytest.mark.asyncio
async def test_stream_chat_rifiuta_messaggio_troppo_lungo():
    """
    Verifica che messaggi > 5000 caratteri vengano rifiutati immediatamente
    senza invocare il grafo.
    """
    graph_called = False

    async def fake_astream_events(*args, **kwargs):
        nonlocal graph_called
        graph_called = True
        return
        yield  # rende la funzione un generator (mai raggiunto)

    mock_graph = MagicMock()
    mock_graph.astream_events = fake_astream_events

    service, *_ = _make_service(mock_graph)

    chunks = []
    async for chunk in service.stream_chat(user_id="test-uuid", user_message="x" * 5001):
        chunks.append(chunk)

    assert len(chunks) == 1
    assert "troppo lungo" in chunks[0]
    assert not graph_called


@pytest.mark.asyncio
async def test_stream_chat_ignora_chunk_non_stringa():
    """
    Verifica che i chunk il cui content non è una stringa (es. tool_call dict)
    non vengano inclusi nello stream testuale.
    """
    mock_graph = MagicMock()

    async def fake_astream_events(*args, **kwargs):
        # chunk con content dict (tool call info) — deve essere ignorato
        yield {"event": "on_chat_model_stream", "data": {"chunk": AIMessageChunk(content=[{"type": "tool_use"}])}}
        yield _stream_event("Testo valido.")

    mock_graph.astream_events = fake_astream_events
    mock_graph.aget_state = AsyncMock(return_value=_no_interrupt_state())

    service, *_ = _make_service(mock_graph)

    chunks = []
    async for chunk in service.stream_chat(user_id="test-uuid", user_message="Ciao"):
        chunks.append(chunk)

    assert "".join(chunks) == "Testo valido."


# ---------------------------------------------------------------------------
# resume_chat
# ---------------------------------------------------------------------------

@pytest.mark.asyncio
async def test_resume_chat_confermato_streama_risultato():
    """
    Verifica che resume_chat(confirmed=True) streami il contenuto del grafo
    senza prefisso di annullamento.
    """
    mock_graph = MagicMock()

    async def fake_astream_events(*args, **kwargs):
        yield _stream_event("Attività avviata con successo!")

    mock_graph.astream_events = fake_astream_events

    service, *_ = _make_service(mock_graph)

    chunks = []
    async for chunk in service.resume_chat(user_id="test-uuid", confirmed=True):
        chunks.append(chunk)

    full = "".join(chunks)
    assert "Attività avviata con successo!" in full
    assert "Annullamento" not in full


@pytest.mark.asyncio
async def test_resume_chat_rifiutato_emette_messaggio_annullamento():
    """
    Verifica che resume_chat(confirmed=False) emetta prima il messaggio di
    annullamento e poi il testo alternativo dell'LLM.
    """
    mock_graph = MagicMock()

    async def fake_astream_events(*args, **kwargs):
        yield _stream_event("Nessun problema, ecco un'alternativa.")

    mock_graph.astream_events = fake_astream_events

    service, *_ = _make_service(mock_graph)

    chunks = []
    async for chunk in service.resume_chat(user_id="test-uuid", confirmed=False):
        chunks.append(chunk)

    full = "".join(chunks)
    assert "Annullamento" in full
    assert "Nessun problema, ecco un'alternativa." in full
