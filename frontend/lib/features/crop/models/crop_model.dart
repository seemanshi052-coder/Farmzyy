class CropRecommendRequest {
  final double nitrogen;
  final double phosphorus;
  final double potassium;
  final double ph;
  final String location;

  CropRecommendRequest({
    required this.nitrogen,
    required this.phosphorus,
    required this.potassium,
    required this.ph,
    required this.location,
  });

  Map<String, dynamic> toJson() => {
        'nitrogen': nitrogen,
        'phosphorus': phosphorus,
        'potassium': potassium,
        'ph': ph,
        'location': location,
      };
}

class CropRecommendResult {
  final String prediction;
  final double confidence_score;

  CropRecommendResult({
    required this.prediction,
    required this.confidence_score,
  });

  factory CropRecommendResult.fromJson(Map<String, dynamic> json) {
    return CropRecommendResult(
      prediction: json['prediction'],
      confidence_score: (json['confidence_score'] as num).toDouble(),
    );
  }
}
