/// Base exception class for the app
abstract class AppException implements Exception {
  final String message;
  final dynamic originalError;
  final StackTrace? stackTrace;

  AppException({
    required this.message,
    this.originalError,
    this.stackTrace,
  });

  @override
  String toString() => message;
}

/// Network related exceptions
class NetworkException extends AppException {
  NetworkException({
    required String message,
    dynamic originalError,
    StackTrace? stackTrace,
  }) : super(
    message: message,
    originalError: originalError,
    stackTrace: stackTrace,
  );
}

/// Server/API related exceptions
class ServerException extends AppException {
  final int? statusCode;

  ServerException({
    required String message,
    this.statusCode,
    dynamic originalError,
    StackTrace? stackTrace,
  }) : super(
    message: message,
    originalError: originalError,
    stackTrace: stackTrace,
  );
}

/// Timeout exceptions
class TimeoutException extends AppException {
  TimeoutException({
    required String message,
    dynamic originalError,
    StackTrace? stackTrace,
  }) : super(
    message: message,
    originalError: originalError,
    stackTrace: stackTrace,
  );
}

/// Authentication related exceptions
class AuthException extends AppException {
  AuthException({
    required String message,
    dynamic originalError,
    StackTrace? stackTrace,
  }) : super(
    message: message,
    originalError: originalError,
    stackTrace: stackTrace,
  );
}

/// Validation exceptions
class ValidationException extends AppException {
  ValidationException({
    required String message,
    dynamic originalError,
    StackTrace? stackTrace,
  }) : super(
    message: message,
    originalError: originalError,
    stackTrace: stackTrace,
  );
}

/// Cache related exceptions
class CacheException extends AppException {
  CacheException({
    required String message,
    dynamic originalError,
    StackTrace? stackTrace,
  }) : super(
    message: message,
    originalError: originalError,
    stackTrace: stackTrace,
  );
}
