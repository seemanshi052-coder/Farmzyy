class ApiResponse<T> {
  final bool success;
  final T? data;
  final String? message;
  final ApiError? error;

  ApiResponse({
    required this.success,
    this.data,
    this.message,
    this.error,
  });

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic)? fromJson,
  ) {
    if (json['success'] == true) {
      return ApiResponse(
        success: true,
        data: fromJson != null && json['data'] != null
            ? fromJson(json['data'])
            : null,
        message: json['message'],
      );
    } else {
      final errorJson = json['error'];
      return ApiResponse(
        success: false,
        error: ApiError(
          code: errorJson?['code'] ?? 400,
          message: errorJson?['message'] ?? 'Unknown error',
        ),
      );
    }
  }

  factory ApiResponse.error(ApiError error) {
    return ApiResponse(success: false, error: error);
  }
}

class ApiError {
  final int code;
  final String message;

  ApiError({required this.code, required this.message});
}
