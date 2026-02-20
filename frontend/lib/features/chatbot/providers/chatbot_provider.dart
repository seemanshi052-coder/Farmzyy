import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../auth/providers/auth_provider.dart';
import '../models/chatbot_model.dart';
import '../services/chatbot_service.dart';

final chatbotServiceProvider = Provider<ChatbotService>(
  (ref) => ChatbotService(ref.read(apiClientProvider)),
);

class ChatState {
  final List<ChatMessage> messages;
  final bool isTyping;
  final String? error;

  ChatState({
    this.messages = const [],
    this.isTyping = false,
    this.error,
  });

  ChatState copyWith({
    List<ChatMessage>? messages,
    bool? isTyping,
    String? error,
  }) {
    return ChatState(
      messages: messages ?? this.messages,
      isTyping: isTyping ?? this.isTyping,
      error: error,
    );
  }
}

class ChatNotifier extends StateNotifier<ChatState> {
  final ChatbotService _service;
  final String _userId;

  ChatNotifier(this._service, this._userId) : super(ChatState());

  Future<void> sendMessage(String message) async {
    final userMsg = ChatMessage(text: message, isUser: true);
    state = state.copyWith(
      messages: [...state.messages, userMsg],
      isTyping: true,
      error: null,
    );

    final request = ChatbotRequest(
      user_id: _userId,
      message: message,
      context: ChatContext(
        soil_type: 'loam',
        crop_stage: 'growing',
        location: 'Delhi',
      ),
    );

    final response = await _service.ask(request);

    if (response.success && response.data != null) {
      final botMsg = ChatMessage(
        text: response.data!.reply,
        isUser: false,
      );
      state = state.copyWith(
        messages: [...state.messages, botMsg],
        isTyping: false,
      );
    } else {
      state = state.copyWith(
        isTyping: false,
        error: response.error?.message ?? 'Failed to get response',
      );
    }
  }

  void clearChat() => state = ChatState();
}

final chatProvider = StateNotifierProvider<ChatNotifier, ChatState>(
  (ref) {
    final userId = ref.watch(authProvider).userId ?? '';
    return ChatNotifier(ref.read(chatbotServiceProvider), userId);
  },
);
