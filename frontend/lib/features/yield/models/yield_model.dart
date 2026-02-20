class YieldPredictRequest {
  final String crop;
  final double land_size;
  final double fertilizer_usage;
  final String location;

  YieldPredictRequest({
    required this.crop,
    required this.land_size,
    required this.fertilizer_usage,
    required this.location,
  });

  Map<String, dynamic> toJson() => {
        'crop': crop,
        'land_size': land_size,
        'fertilizer_usage': fertilizer_usage,
        'location': location,
      };
}

class YieldPredictResult {
  final String prediction;
  final double confidence_score;

  YieldPredictResult({
    required this.prediction,
    required this.confidence_score,
  });

  factory YieldPredictResult.fromJson(Map<String, dynamic> json) {
    return YieldPredictResult(
      prediction: json['prediction'],
      confidence_score: (json['confidence_score'] as num).toDouble(),
    );
  }
}
