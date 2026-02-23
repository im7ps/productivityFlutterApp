import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:speech_to_text/speech_to_text.dart';
import '../domain/chat_message.dart';
import '../domain/chat_state.dart';
import '../data/speech_to_text_provider.dart';
import '../data/permission_provider.dart';
import '../data/chat_repository.dart';
import 'package:uuid/uuid.dart';

part 'chat_controller.g.dart';

@riverpod
class ChatController extends _$ChatController {
  SpeechToText get _speech => ref.read(speechToTextProvider);
  
  @override
  ChatState build() {
    return const ChatState();
  }

  bool _isListening = false;
  bool get isListening => _isListening;

  static const _confirmTag = "||INTERRUPT||";

  Future<bool> toggleListening() async {
    // 1. Check & Request Permissions via service
    final hasPermission = await ref.read(permissionServiceProvider).requestMicrophonePermission();
    if (!hasPermission) return false;

    if (_isListening) {
      await _speech.stop();
      _isListening = false;
      state = state; // Trigger update if needed (isListening isn't in ChatState yet)
      return false;
    }

    bool available = await _speech.initialize(
      onStatus: (status) {
        if (status == 'done' || status == 'notListening') {
          _isListening = false;
          state = state; 
        }
      },
      onError: (errorNotification) {
        _isListening = false;
        state = state;
      },
    );

    if (available) {
      _isListening = true;
      state = state;
      _speech.listen(
        onResult: (result) {
          if (result.finalResult) {
            addUserMessage(result.recognizedWords);
          }
        },
      );
    }
    return available;
  }

  void addUserMessage(String text) {
    if (text.isEmpty) return;
    
    final message = ChatMessage(
      id: const Uuid().v4(),
      text: text,
      isUser: true,
      timestamp: DateTime.now(),
    );
    
    state = state.copyWith(
      messages: [...state.messages, message],
    );
    
    // Avvia streaming reale dal backend
    _startAIStreaming(text);
  }

  Future<void> _startAIStreaming(String userText) async {
    final repository = ref.read(chatRepositoryProvider);
    
    final responseId = const Uuid().v4();
    final initialResponse = ChatMessage(
      id: responseId,
      text: "",
      isUser: false,
      timestamp: DateTime.now(),
    );
    
    state = state.copyWith(
      messages: [...state.messages, initialResponse],
    );

    StringBuffer fullText = StringBuffer();
    
    try {
      await for (final chunk in repository.streamChat(userText)) {
        fullText.write(chunk);

        String displayText = fullText.toString();
        bool waiting = false;
        if (displayText.contains(_confirmTag)) {
          waiting = true;
          displayText = displayText.replaceAll(_confirmTag, "").trim();
        }

        // Aggiorna l'ultimo messaggio (la risposta AI) nel state
        state = state.copyWith(
          isWaitingConfirmation: waiting,
          messages: [
            for (final msg in state.messages)
              if (msg.id == responseId)
                msg.copyWith(text: displayText)
              else
                msg
          ],
        );
      }
    } catch (e) {
      // Gestione errore base
      state = state.copyWith(
        messages: [
          for (final msg in state.messages)
            if (msg.id == responseId)
              msg.copyWith(text: "Errore nella comunicazione con l'AI: $e")
            else
              msg
        ],
      );
    }
  }

  Future<void> confirmAction(bool confirmed) async {
    state = state.copyWith(isWaitingConfirmation: false);

    final repository = ref.read(chatRepositoryProvider);
    final responseId = const Uuid().v4();

    state = state.copyWith(
      messages: [
        ...state.messages,
        ChatMessage(
          id: responseId,
          text: "",
          isUser: false,
          timestamp: DateTime.now(),
        ),
      ],
    );

    final fullText = StringBuffer();

    try {
      await for (final chunk in repository.confirmTool(confirmed)) {
        fullText.write(chunk);
        
        String displayText = fullText.toString();
        bool waiting = false;
        if (displayText.contains(_confirmTag)) {
          waiting = true;
          displayText = displayText.replaceAll(_confirmTag, "").trim();
        }

        state = state.copyWith(
          isWaitingConfirmation: waiting,
          messages: [
            for (final msg in state.messages)
              if (msg.id == responseId)
                msg.copyWith(text: displayText)
              else
                msg
          ],
        );
      }
    } catch (e) {
      state = state.copyWith(
        messages: [
          for (final msg in state.messages)
            if (msg.id == responseId)
              msg.copyWith(text: "Errore nella comunicazione con l'AI: $e")
            else
              msg
        ],
      );
    }
  }
}

