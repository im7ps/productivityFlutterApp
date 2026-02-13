import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:speech_to_text/speech_to_text.dart';
import '../domain/chat_message.dart';
import '../data/speech_to_text_provider.dart';
import '../data/permission_provider.dart';
import '../data/chat_repository.dart';
import 'package:uuid/uuid.dart';

part 'chat_controller.g.dart';

@riverpod
class ChatController extends _$ChatController {
  SpeechToText get _speech => ref.read(speechToTextProvider);
  
  @override
  List<ChatMessage> build() {
    return [];
  }

  bool _isListening = false;
  bool get isListening => _isListening;

  Future<bool> toggleListening() async {
    // 1. Check & Request Permissions via service
    final hasPermission = await ref.read(permissionServiceProvider).requestMicrophonePermission();
    if (!hasPermission) return false;

    if (_isListening) {
      await _speech.stop();
      _isListening = false;
      ref.notifyListeners();
      return false;
    }

    bool available = await _speech.initialize(
      onStatus: (status) {
        if (status == 'done' || status == 'notListening') {
          _isListening = false;
          ref.notifyListeners();
        }
      },
      onError: (errorNotification) {
        _isListening = false;
        ref.notifyListeners();
      },
    );

    if (available) {
      _isListening = true;
      ref.notifyListeners();
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
    
    state = [...state, message];
    
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
    
    state = [...state, initialResponse];

    StringBuffer fullText = StringBuffer();
    
    try {
      await for (final chunk in repository.streamChat(userText)) {
        fullText.write(chunk);
        
        // Aggiorna l'ultimo messaggio (la risposta AI) nel state
        state = [
          for (final msg in state)
            if (msg.id == responseId)
              msg.copyWith(text: fullText.toString())
            else
              msg
        ];
      }
    } catch (e) {
      // Gestione errore base
      state = [
        for (final msg in state)
          if (msg.id == responseId)
            msg.copyWith(text: "Errore nella comunicazione con l'AI: $e")
          else
            msg
      ];
    }
  }
}
