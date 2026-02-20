import '../../../core/api/api_client.dart';
import '../../../core/api/api_response.dart';
import '../../../core/constants/app_constants.dart';
import '../models/yield_model.dart';

class YieldService {
  final ApiClient _client;
  YieldService(this._client);

  Future<ApiResponse<YieldPredictResult>> predict(
      YieldPredictRequest request) {
    return _client.post<YieldPredictResult>(
      AppConstants.yieldPredictEndpoint,
      data: request.toJson(),
      fromJson: (json) => YieldPredictResult.fromJson(json),
    );
  }
}
