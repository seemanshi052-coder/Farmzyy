import '../../../core/api/api_client.dart';
import '../../../core/api/api_response.dart';
import '../../../core/constants/app_constants.dart';
import '../models/auth_model.dart';

class AuthService {
  final ApiClient _client;
  AuthService(this._client);

  Future<ApiResponse<AuthModel>> login(LoginRequest request) {
    return _client.post<AuthModel>(
      AppConstants.loginEndpoint,
      data: request.toJson(),
      fromJson: (json) => AuthModel.fromJson(json),
    );
  }
}
