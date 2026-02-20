class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;

  ChatMessage({
    required this.text,
    required this.isUser,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();
}

class ChatbotRequest {
  final String user_id;
  final String message;
  final ChatContext context;

  ChatbotRequest({
    required this.user_id,
    required this.message,
    required this.context,
  });

  Map<String, dynamic> toJson() => {
        'user_id': user_id,
        'message': message,
        'context': context.toJson(),
      };
}

class ChatContext {
  final String soil_type;
  final String crop_stage;
  final String location;

  ChatContext({
    required this.soil_type,
    required this.crop_stage,
    required this.location,
  });

  Map<String, dynamic> toJson() => {
        'soil_type': soil_type,
        'crop_stage': crop_stage,
        'location': location,
      };
}

class ChatbotResponse {
  final String reply;
  final double confidence_score;
  final List<String> suggested_actions;

  ChatbotResponse({
    required this.reply,
    required this.confidence_score,
    required this.suggested_actions,
  });

  factory ChatbotResponse.fromJson(Map<String, dynamic> json) {
    return ChatbotResponse(
      reply: json['reply'],
      confidence_score: (json['confidence_score'] as num).toDouble(),
      suggested_actions: List<String>.from(json['suggested_actions'] ?? []),
    );
  }
}
