/// Prediction Response Model
class PredictionData {
  final String prediction;
  final double confidenceScore;
  final String reasoning;
  final String riskLevel;

  PredictionData({
    required this.prediction,
    required this.confidenceScore,
    required this.reasoning,
    required this.riskLevel,
  });

  factory PredictionData.fromJson(Map<String, dynamic> json) {
    return PredictionData(
      prediction: json['prediction'] as String? ?? '',
      confidenceScore: (json['confidence_score'] as num?)?.toDouble() ?? 0.0,
      reasoning: json['reasoning'] as String? ?? '',
      riskLevel: json['risk_level'] as String? ?? 'Low',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'prediction': prediction,
      'confidence_score': confidenceScore,
      'reasoning': reasoning,
      'risk_level': riskLevel,
    };
  }

  /// Get color based on risk level
  String getRiskColor() {
    switch (riskLevel.toLowerCase()) {
      case 'high':
        return '#D32F2F'; // Red
      case 'medium':
        return '#F57F17'; // Yellow
      case 'low':
        return '#388E3C'; // Green
      default:
        return '#757575'; // Gray
    }
  }

  /// Get icon representing prediction type
  String getIcon() {
    if (riskLevel.toLowerCase() == 'high') {
      return '⚠️';
    } else if (riskLevel.toLowerCase() == 'medium') {
      return '⚡';
    } else {
      return '✅';
    }
  }
}
