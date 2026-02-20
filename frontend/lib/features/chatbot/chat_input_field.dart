import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../config/theme.dart';
import 'chatbot_provider.dart';

class ChatInputField extends ConsumerStatefulWidget {
  final String userId;
  final Map<String, String>? contextData;

  const ChatInputField({
    super.key,
    required this.userId,
    this.contextData,
  });

  @override
  ConsumerState<ChatInputField> createState() => _ChatInputFieldState();
}

class _ChatInputFieldState extends ConsumerState<ChatInputField> {
  final TextEditingController _controller = TextEditingController();
  bool _isSending = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    setState(() => _isSending = true);

    final notifier = ref.read(chatbotMessagesProvider.notifier);
    await notifier.ask(user_id: widget.userId, message: text, context: widget.contextData);

    _controller.clear();
    setState(() => _isSending = false);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppTheme.paddingSmall, vertical: 8),
      decoration: const BoxDecoration(color: Colors.white),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(
                hintText: 'Ask about soil, crops, pests...',
                border: InputBorder.none,
              ),
              onSubmitted: (_) => _send(),
            ),
          ),
          IconButton(
            icon: _isSending ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2)) : const Icon(Icons.send),
            onPressed: _isSending ? null : _send,
          )
        ],
      ),
    );
  }
}
