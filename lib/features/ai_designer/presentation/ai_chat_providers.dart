import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/models/chat_message.dart';
import '../data/ai_chat_repository.dart';

final aiChatRepositoryProvider = Provider<AiChatRepository>(
  (ref) => const MockAiChatRepository(),
);

/// Immutable chat state: the message list plus a typing indicator.
class AiChatState {
  const AiChatState({this.messages = const [], this.isTyping = false});

  final List<ChatMessage> messages;
  final bool isTyping;

  AiChatState copyWith({List<ChatMessage>? messages, bool? isTyping}) =>
      AiChatState(
        messages: messages ?? this.messages,
        isTyping: isTyping ?? this.isTyping,
      );
}

/// Drives the local mock chat. Appends the user message immediately, shows a
/// typing indicator, then appends the mock designer reply.
class AiChatController extends StateNotifier<AiChatState> {
  AiChatController(this._repo)
      : super(AiChatState(messages: [
          ChatMessage(
            role: ChatRole.assistant,
            text:
                'مرحبًا بك في مصمم Odem 👋\nصف لي غرفتك (النوع، الطراز، الميزانية) وسأساعدك في اختيار قطع متناسقة.',
            time: DateTime.now(),
          ),
        ]));

  final AiChatRepository _repo;

  Future<void> send(String text) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty || state.isTyping) return;

    final userMsg = ChatMessage(
      role: ChatRole.user,
      text: trimmed,
      time: DateTime.now(),
    );
    state = state.copyWith(
      messages: [...state.messages, userMsg],
      isTyping: true,
    );

    final replyText =
        await _repo.reply(trimmed, history: state.messages);

    final reply = ChatMessage(
      role: ChatRole.assistant,
      text: replyText,
      time: DateTime.now(),
    );
    state = state.copyWith(
      messages: [...state.messages, reply],
      isTyping: false,
    );
  }
}

final aiChatControllerProvider =
    StateNotifierProvider<AiChatController, AiChatState>(
  (ref) => AiChatController(ref.watch(aiChatRepositoryProvider)),
);
