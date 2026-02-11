import 'package:dio/dio.dart';

/// Custom exception for API errors.
class ApiException implements Exception {
  const ApiException({
    required this.message,
    this.statusCode,
    this.errorCode,
  });

  final String message;
  final int? statusCode;
  final String? errorCode;

  @override
  String toString() {
    if (statusCode != null) {
      return 'ApiException: $message (statusCode: $statusCode)';
    }
    return 'ApiException: $message';
  }

  static ApiException fromDioError(DioException error) {
    final statusCode = error.response?.statusCode;

    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.sendTimeout ||
        error.type == DioExceptionType.receiveTimeout) {
      return const ApiException(
        message: 'Request timed out. Please try again.',
      );
    }

    if (error.type == DioExceptionType.connectionError) {
      return const ApiException(
        message: 'No internet connection. Please check your network.',
      );
    }

    if (error.type == DioExceptionType.cancel) {
      return const ApiException(
        message: 'Request was cancelled.',
      );
    }

    if (error.type == DioExceptionType.badResponse) {
      return _handleBadResponse(error, statusCode);
    }

    return ApiException(
      message: error.message ?? 'An unknown error occurred. Please try again.',
    );
  }

  static ApiException _handleBadResponse(DioException error, int? statusCode) {
    final data = error.response?.data;
    String message = 'Something went wrong';
    String? errorCode;

    if (data is Map<String, dynamic>) {
      message = data['message'] as String? ?? message;
      errorCode = data['code'] as String?;
    } else if (data is String) {
      message = data;
    }

    return switch (statusCode) {
      400 => ApiException(
          message: message,
          statusCode: statusCode,
          errorCode: errorCode,
        ),
      401 => const ApiException(
          message: 'Authentication failed. Please login again.',
          statusCode: 401,
        ),
      403 => const ApiException(
          message: 'You do not have permission to access this resource.',
          statusCode: 403,
        ),
      404 => ApiException(
          message: message,
          statusCode: statusCode,
          errorCode: errorCode,
        ),
      500 || 502 || 503 => const ApiException(
          message: 'Server error. Please try again later.',
          statusCode: 500,
        ),
      _ => ApiException(
          message: message,
          statusCode: statusCode,
          errorCode: errorCode,
        ),
    };
  }
}
