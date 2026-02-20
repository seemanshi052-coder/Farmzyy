import '../../../core/api/api_client.dart';
import '../../../core/api/api_response.dart';
import '../../../core/constants/app_constants.dart';
import '../models/chatbot_model.dart';

class ChatbotService {
  final ApiClient _client;
  ChatbotService(this._client);

  Future<ApiResponse<ChatbotResponse>> ask(ChatbotRequest request) {
    return _client.post<ChatbotResponse>(
      AppConstants.chatbotEndpoint,
      data: request.toJson(),
      fromJson: (json) => ChatbotResponse.fromJson(json),
    );
  }
}
