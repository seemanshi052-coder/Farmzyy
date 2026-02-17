import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/auth_models.dart';
import '../../data/services/api_service.dart';
import '../../config/api_config.dart';
import '../../data/providers/api_service_provider.dart';

class ChatbotMessage {
  final String message;
  final String? reply;
  final double? confidence_score;
  final List<String>? suggested_actions;
  final bool isUser;

  ChatbotMessage({
    required this.message,
    this.reply,
    this.confidence_score,
    this.suggested_actions,
    this.isUser = false,
  });
}

final chatbotMessagesProvider = StateNotifierProvider<ChatbotNotifier, List<ChatbotMessage>>((ref) {
  return ChatbotNotifier(ref: ref);
});

class ChatbotNotifier extends StateNotifier<List<ChatbotMessage>> {
  final Ref ref;

  ChatbotNotifier({required this.ref}) : super([]);

  void addUserMessage(String message) {
    state = [
      ...state,
      ChatbotMessage(message: message, isUser: true),
    ];
  }

  void addBotMessage({required String reply, required double confidence_score, List<String>? suggested_actions}) {
    state = [
      ...state,
      ChatbotMessage(
        message: reply,
        reply: reply,
        confidence_score: confidence_score,
        suggested_actions: suggested_actions,
        isUser: false,
      ),
    ];
  }

  Future<void> ask({required String user_id, required String message, Map<String, String>? context}) async {
    addUserMessage(message);

    final body = {
      'user_id': user_id,
      'message': message,
      'context': {
        'soil_type': context?['soil_type'] ?? '',
        'crop_stage': context?['crop_stage'] ?? '',
        'location': context?['location'] ?? '',
      }
    };

    try {
      final apiService = await ref.read(apiServiceProvider.future);
      final response = await apiService.post<Map<String, dynamic>>(
        ApiConfig.chatbotAskEndpoint,
        data: body,
        fromJsonT: (json) => json as Map<String, dynamic>,
      );

      if (response.success && response.data != null) {
        final data = response.data!;
        final reply = data['reply'] as String? ?? '';
        final confidence = (data['confidence_score'] as num?)?.toDouble() ?? 0.0;
        final suggested = data['suggested_actions'] != null
            ? List<String>.from(data['suggested_actions'] as List)
            : <String>[];

        addBotMessage(reply: reply, confidence_score: confidence, suggested_actions: suggested);
      } else {
        addBotMessage(reply: 'Sorry, I could not get a response.', confidence_score: 0.0, suggested_actions: []);
      }
    } catch (e) {
      addBotMessage(reply: 'Error: ${e.toString()}', confidence_score: 0.0, suggested_actions: []);
    }
  }
}
