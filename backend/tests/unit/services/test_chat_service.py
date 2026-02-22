import pytest
import json
from unittest.mock import AsyncMock, MagicMock, patch
from app.services.chat_service import ChatService
from langchain_core.messages import AIMessage

@pytest.mark.asyncio
async def test_chat_service_injection_and_streaming():
    """
    Verifica che il ChatService recuperi correttamente il contesto utente (Rank, Portfolio, Proposals)
    e lo inietti nel grafo di LangGraph, restituendo i chunk in streaming.
    """
    # 1. Mock delle dipendenze
    mock_user_service = AsyncMock()
    mock_action_service = AsyncMock()
    mock_consultant_service = AsyncMock()
    
    # Mock dell'utente
    mock_user = MagicMock()
    mock_user.rank_score = 42
    mock_user_service.get_user_by_id.return_value = mock_user
    
    # Mock delle azioni nel portfolio
    mock_action = MagicMock()
    mock_action.description = "Meditazione"
    mock_action.category = "Salute"
    mock_action_service.get_user_portfolio.return_value = [mock_action]
    
    # Mock delle proposte
    mock_proposal = MagicMock()
    mock_proposal.description = "Allenamento"
    mock_proposal.category = "Fitness"
    mock_consultant_service.get_proposals.return_value = [mock_proposal]

    # Inizializziamo il servizio
    service = ChatService(
        user_service=mock_user_service,
        action_service=mock_action_service,
        consultant_service=mock_consultant_service
    )

    # 2. Mock di app_graph.astream
    async def mock_astream_generator(*args, **kwargs):
        # LangGraph restituisce chunk con il nome del nodo
        yield {"agent": {"messages": [AIMessage(content="Risposta ")]}}
        yield {"agent": {"messages": [AIMessage(content="mockata.")]}}

    # Patchiamo app_graph importato nel modulo chat_service
    with patch("app.services.chat_service.app_graph.astream", side_effect=mock_astream_generator):
        # 3. Esecuzione
        responses = []
        async for chunk in service.stream_chat(user_id="test-uuid", user_message="Cosa dovrei fare?"):
            responses.append(chunk)

        # 4. Verifiche
        full_response = "".join(responses)
        assert full_response == "Risposta mockata."
        
        # Verifica recupero dati
        mock_user_service.get_user_by_id.assert_called_once()
        mock_action_service.get_user_portfolio.assert_called_once_with("test-uuid")
        mock_consultant_service.get_proposals.assert_called_once_with("test-uuid")
        
        print(f"✅ Test completato con successo. Risposta ricevuta: {full_response}")

if __name__ == "__main__":
    pytest.main([__file__])
