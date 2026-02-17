/// Standard API response model matching backend format
class ApiResponse<T> {
  final bool success;
  final T? data;
  final String? message;
  final ErrorResponse? error;

  ApiResponse({
    required this.success,
    this.data,
    this.message,
    this.error,
  });

  /// Create ApiResponse from JSON
  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic)? dataParser,
  ) {
    return ApiResponse(
      success: json['success'] ?? false,
      data: json['data'] != null && dataParser != null ? dataParser(json['data']) : null,
      message: json['message'],
      error: json['error'] != null ? ErrorResponse.fromJson(json['error']) : null,
    );
  }

  /// Check if response is successful
  bool get isSuccess => success && error == null;

  /// Get error message
  String? get errorMessage => error?.message ?? message;
}

/// Standard error response model
class ErrorResponse {
  final int code;
  final String message;

  ErrorResponse({
    required this.code,
    required this.message,
  });

  /// Create ErrorResponse from JSON
  factory ErrorResponse.fromJson(Map<String, dynamic> json) {
    return ErrorResponse(
      code: json['code'] ?? 0,
      message: json['message'] ?? 'Unknown error',
    );
  }
}
