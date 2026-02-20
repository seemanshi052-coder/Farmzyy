import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../config/theme.dart';
import '../../data/models/auth_models.dart';
import 'chatbot_provider.dart';
import 'message_bubble.dart';
import 'chat_input_field.dart';

class ChatbotScreen extends ConsumerWidget {
  final String userId;
  final Map<String, String>? contextData;

  const ChatbotScreen({super.key, required this.userId, this.contextData});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final messages = ref.watch(chatbotMessagesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Farmzyy Assistant'),
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(AppTheme.paddingMedium),
              child: ListView.builder(
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final m = messages[index];
                  return Align(
                    alignment: m.isUser ? Alignment.centerRight : Alignment.centerLeft,
                    child: MessageBubble(
                      text: m.message,
                      isUser: m.isUser,
                      confidenceScore: m.confidence_score,
                      suggestedActions: m.suggested_actions,
                    ),
                  );
                },
              ),
            ),
          ),
          Divider(height: 1),
          ChatInputField(userId: userId, contextData: contextData),
        ],
      ),
    );
  }
}
