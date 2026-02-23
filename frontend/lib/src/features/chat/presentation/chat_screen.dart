import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import 'chat_controller.dart';
import '../domain/chat_message.dart';
import '../domain/chat_state.dart';

class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final ScrollController _scrollController = ScrollController();
  double? _firstUnreadOffset;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.hasClients) {
      // Se l'utente raggiunge il fondo, resettiamo l'offset dei messaggi non letti
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 50) {
        setState(() {
          _firstUnreadOffset = null;
        });
      }
    }
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _scrollToOffset(double offset) {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        offset,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final chatState = ref.watch(chatControllerProvider);
    final messages = chatState.messages;
    final theme = Theme.of(context);

    // Listen for new messages to scroll
    ref.listen<ChatState>(chatControllerProvider, (previous, next) {
      if (next.messages.length > (previous?.messages.length ?? 0)) {
        final lastMessage = next.messages.last;

        if (lastMessage.isUser) {
          // Messaggio dell'utente: scroll immediato in fondo
          _firstUnreadOffset = null;
          WidgetsBinding.instance.addPostFrameCallback(
            (_) => _scrollToBottom(),
          );
        } else {
          // Messaggio AI: scroll all'inizio del nuovo messaggio
          // Se non stiamo già tracciando un messaggio non letto, salviamo l'offset
          if (_firstUnreadOffset == null) {
            final oldMaxScroll = _scrollController.hasClients
                ? _scrollController.position.maxScrollExtent
                : 0.0;

            _firstUnreadOffset = oldMaxScroll;
            WidgetsBinding.instance.addPostFrameCallback(
              (_) => _scrollToOffset(oldMaxScroll),
            );
          }
        }
      }
    });

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppColors.white,
          ),
          onPressed: () => context.pop(),
        ),
        title: Text(
          "AI CONSULTANT",
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              reverse: false,
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                return _ChatBubble(message: message);
              },
            ),
          ),
          _ChatInputSection(),
        ],
      ),
    );
  }
}

class _ChatBubble extends StatelessWidget {
  final ChatMessage message;

  const _ChatBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    final isUser = message.isUser;
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isUser ? AppColors.dovere : AppColors.surface,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(isUser ? 16 : 0),
            bottomRight: Radius.circular(isUser ? 0 : 16),
          ),
        ),
        child: Column(
          crossAxisAlignment: isUser
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: [
            Text(
              message.text,
              style: const TextStyle(color: AppColors.white, fontSize: 16),
            ),
            const SizedBox(height: 4),
            Text(
              "${message.timestamp.hour}:${message.timestamp.minute.toString().padLeft(2, '0')}",
              style: const TextStyle(color: AppColors.grey, fontSize: 10),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChatInputSection extends ConsumerStatefulWidget {
  @override
  ConsumerState<_ChatInputSection> createState() => _ChatInputSectionState();
}

class _ChatInputSectionState extends ConsumerState<_ChatInputSection> {
  final TextEditingController _textController = TextEditingController();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _handleSend() {
    final text = _textController.text.trim();
    if (text.isNotEmpty) {
      ref.read(chatControllerProvider.notifier).addUserMessage(text);
      _textController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final chatState = ref.watch(chatControllerProvider);
    final isWaitingConfirmation = chatState.isWaitingConfirmation;
    final controller = ref.watch(chatControllerProvider.notifier);
    final isListening = controller.isListening;

    if (isWaitingConfirmation) {
      return _buildConfirmationBar();
    }

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _textController,
              decoration: InputDecoration(
                hintText: isListening
                    ? "Sto ascoltando..."
                    : "Chiedi qualcosa...",
                border: InputBorder.none,
                hintStyle: const TextStyle(color: AppColors.grey),
              ),
              style: const TextStyle(color: AppColors.white),
              onSubmitted: (_) => _handleSend(),
            ),
          ),
          IconButton(
            icon: Icon(
              isListening ? Icons.mic : Icons.mic_none_rounded,
              color: isListening ? AppColors.passione : AppColors.white,
              size: 28,
            ),
            onPressed: () async {
              await ref.read(chatControllerProvider.notifier).toggleListening();
              setState(() {}); // Aggiorno UI per lo stato del microfono
            },
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.send_rounded, color: AppColors.dovere),
            onPressed: _handleSend,
          ),
        ],
      ),
    );
  }

  Widget _buildConfirmationBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "Vuoi che esegua questa azione?",
            style: TextStyle(color: AppColors.grey, fontSize: 13),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  icon: const Icon(
                    Icons.close_rounded,
                    color: AppColors.passione,
                    size: 18,
                  ),
                  label: const Text(
                    "Annulla",
                    style: TextStyle(color: AppColors.passione),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.passione),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () => ref
                      .read(chatControllerProvider.notifier)
                      .confirmAction(false),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  icon: const Icon(
                    Icons.check_rounded,
                    color: AppColors.white,
                    size: 18,
                  ),
                  label: const Text(
                    "Conferma",
                    style: TextStyle(color: AppColors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.energia,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () => ref
                      .read(chatControllerProvider.notifier)
                      .confirmAction(true),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
