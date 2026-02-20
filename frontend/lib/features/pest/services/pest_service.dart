import '../../../core/api/api_client.dart';
import '../../../core/api/api_response.dart';
import '../../../core/constants/app_constants.dart';
import '../models/pest_model.dart';

class PestService {
  final ApiClient _client;
  PestService(this._client);

  Future<ApiResponse<PestPredictResult>> predict() {
    return _client.post<PestPredictResult>(
      AppConstants.pestPredictEndpoint,
      fromJson: (json) => PestPredictResult.fromJson(json),
    );
  }
}
