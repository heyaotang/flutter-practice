import 'package:dio/dio.dart';

/// API configuration for network requests.
class ApiConfig {
  ApiConfig._();

  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:3000',
  );

  static const Duration _timeout = Duration(seconds: 15);
  static const Map<String, String> _defaultHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  static BaseOptions get dioOptions => BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: _timeout,
        receiveTimeout: _timeout,
        sendTimeout: _timeout,
        headers: _defaultHeaders,
        responseType: ResponseType.json,
      );
}
