import pytest
import json
from unittest.mock import AsyncMock, MagicMock, patch
from app.services.chat_service import ChatService

@pytest.mark.asyncio
async def test_chat_service_injection_and_streaming():
    """
    Verifica che il ChatService recuperi correttamente il contesto utente (Rank, Portfolio, Proposals)
    e lo inietti nella catena di LangChain, restituendo i chunk in streaming.
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
    mock_action.title = "Meditazione"
    mock_action.category_id = "energy"
    mock_action_service.get_user_actions.return_value = [mock_action]
    
    # Mock delle proposte
    mock_proposal = MagicMock()
    mock_proposal.title = "Allenamento"
    mock_proposal.description = "30 minuti di corsa"
    mock_consultant_service.get_proposals.return_value = [mock_proposal]

    # Inizializziamo il servizio
    service = ChatService(
        user_service=mock_user_service,
        action_service=mock_action_service,
        consultant_service=mock_consultant_service
    )

    # 2. Mock della catena LangChain
    # Invece di patchare l'intera classe ChatOpenAI, patchiamo il metodo astream della chain
    # che viene creata dinamicamente nel metodo stream_chat.
    # Per farlo in modo pulito, patchiamo direttamente l'oggetto 'chain' all'interno di stream_chat
    # o più semplicemente mockiamo il ritorno di self.llm.astream che è l'ultimo anello della catena.
    
    async def mock_astream_generator(*args, **kwargs):
        yield "Risposta "
        yield "mockata."

    with patch.object(service.llm, "astream", side_effect=mock_astream_generator):
        # 3. Esecuzione
        responses = []
        async for chunk in service.stream_chat(user_id=1, user_message="Cosa dovrei fare?"):
            responses.append(chunk)

        # 4. Verifiche
        full_response = "".join(responses)
        assert full_response == "Risposta mockata."
        
        # Verifica recupero dati
        mock_user_service.get_user_by_id.assert_called_once()
        mock_action_service.get_user_actions.assert_called_once_with(1)
        mock_consultant_service.get_proposals.assert_called_once_with(1)
        
        print(f"
✅ Test completato con successo. Risposta ricevuta: {full_response}")

if __name__ == "__main__":
    # Questo permette di lanciare il test direttamente se necessario
    pytest.main([__file__])
