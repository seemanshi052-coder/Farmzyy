import '../../../core/api/api_client.dart';
import '../../../core/api/api_response.dart';
import '../../../core/constants/app_constants.dart';
import '../models/crop_model.dart';

class CropService {
  final ApiClient _client;
  CropService(this._client);

  Future<ApiResponse<CropRecommendResult>> recommend(
      CropRecommendRequest request) {
    return _client.post<CropRecommendResult>(
      AppConstants.cropRecommendEndpoint,
      data: request.toJson(),
      fromJson: (json) => CropRecommendResult.fromJson(json),
    );
  }
}
