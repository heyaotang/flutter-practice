import 'package:dio/dio.dart';

/// API configuration for network requests.
class ApiConfig {
  ApiConfig._();

  /// Base URL for API requests.
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:3000',
  );

  /// Default connection timeout.
  static const Duration connectTimeout = Duration(seconds: 15);

  /// Default receive timeout.
  static const Duration receiveTimeout = Duration(seconds: 15);

  /// Default send timeout.
  static const Duration sendTimeout = Duration(seconds: 15);

  /// Default request headers.
  static const Map<String, String> defaultHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  /// API endpoints.
  static const String bannersEndpoint = '/get-banners';

  /// Dio options instance.
  static BaseOptions get dioOptions => BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: connectTimeout,
        receiveTimeout: receiveTimeout,
        sendTimeout: sendTimeout,
        headers: defaultHeaders,
        responseType: ResponseType.json,
      );
}
