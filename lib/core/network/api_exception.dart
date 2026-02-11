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

  /// Creates an [ApiException] from a [DioException].
  static ApiException fromDioError(DioException error) {
    final statusCode = error.response?.statusCode;

    // Handle timeout errors.
    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.sendTimeout ||
        error.type == DioExceptionType.receiveTimeout) {
      return const ApiException(
        message: 'Request timed out. Please try again.',
      );
    }

    // Handle connection errors.
    if (error.type == DioExceptionType.connectionError) {
      return const ApiException(
        message: 'No internet connection. Please check your network.',
      );
    }

    // Handle cancelled requests.
    if (error.type == DioExceptionType.cancel) {
      return const ApiException(
        message: 'Request was cancelled.',
      );
    }

    // Handle bad response.
    if (error.type == DioExceptionType.badResponse) {
      return _handleBadResponse(error, statusCode);
    }

    // Handle unknown errors.
    final message =
        error.message ?? 'An unknown error occurred. Please try again.';
    return ApiException(message: message);
  }

  static ApiException _handleBadResponse(DioException error, int? statusCode) {
    final data = error.response?.data;

    String message = 'Something went wrong';
    String? errorCode;

    // Extract error message from response data.
    if (data is Map<String, dynamic>) {
      message = data['message'] as String? ?? message;
      errorCode = data['code'] as String?;
    } else if (data is String) {
      message = data;
    }

    switch (statusCode) {
      case 400:
        return ApiException(
          message: message,
          statusCode: statusCode,
          errorCode: errorCode,
        );

      case 401:
        return const ApiException(
          message: 'Authentication failed. Please login again.',
          statusCode: 401,
        );

      case 403:
        return const ApiException(
          message: 'You do not have permission to access this resource.',
          statusCode: 403,
        );

      case 404:
        return ApiException(
          message: message,
          statusCode: statusCode,
          errorCode: errorCode,
        );

      case 500:
      case 502:
      case 503:
        return const ApiException(
          message: 'Server error. Please try again later.',
          statusCode: 500,
        );

      default:
        return ApiException(
          message: message,
          statusCode: statusCode,
          errorCode: errorCode,
        );
    }
  }
}
