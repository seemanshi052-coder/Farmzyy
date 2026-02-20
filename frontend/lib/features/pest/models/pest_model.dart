class PestPredictResult {
  final String prediction;
  final double confidence_score;
  final String risk_level;

  PestPredictResult({
    required this.prediction,
    required this.confidence_score,
    required this.risk_level,
  });

  factory PestPredictResult.fromJson(Map<String, dynamic> json) {
    return PestPredictResult(
      prediction: json['prediction'],
      confidence_score: (json['confidence_score'] as num).toDouble(),
      risk_level: json['risk_level'],
    );
  }
}
