import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'api_exception.dart';

/// Combined interceptor for logging, auth, and response handling.
class ApiInterceptor extends Interceptor {
  ApiInterceptor({
    this.enableLogging = kDebugMode,
    this.getToken,
    this.extractData = true,
  });

  static const String _successCode = '0';
  static const int _maxLogLength = 1000;
  static const String _defaultErrorMessage = 'Unknown error';

  final bool enableLogging;
  final String? Function()? getToken;
  final bool extractData;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final token = getToken?.call();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    if (enableLogging) _logRequest(options);
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (extractData && response.data is Map<String, dynamic>) {
      final data = response.data as Map<String, dynamic>;
      final code = data['code'] as String?;

      if (code != null && code != _successCode) {
        final message = data['message'] as String? ?? _defaultErrorMessage;
        handler.reject(
          DioException(
            requestOptions: response.requestOptions,
            response: response,
            type: DioExceptionType.badResponse,
            error: ApiException(
              message: message,
              statusCode: response.statusCode,
              errorCode: code,
            ),
          ),
        );
        return;
      }

      if (data.containsKey('data')) {
        response.data = data['data'];
      }
    }

    if (enableLogging) _logResponse(response);
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (enableLogging) _logError(err);
    handler.next(err);
  }

  void _logRequest(RequestOptions options) {
    final buffer = StringBuffer()
      ..writeln('=== API Request ===')
      ..writeln('Method: ${options.method}')
      ..writeln('URL: ${options.uri}')
      ..writeln('Headers: ${options.headers}');

    if (options.data != null) {
      buffer.writeln('Data: ${options.data}');
    } else if (options.queryParameters.isNotEmpty) {
      buffer.writeln('Query: ${options.queryParameters}');
    }

    debugPrint(buffer.toString().trim());
  }

  void _logResponse(Response response) {
    final buffer = StringBuffer()
      ..writeln('=== API Response ===')
      ..writeln('Status: ${response.statusCode}')
      ..writeln('URL: ${response.requestOptions.uri}');

    if (response.data != null) {
      final dataString = response.data.toString();
      final truncated = dataString.length > _maxLogLength
          ? '${dataString.substring(0, _maxLogLength)}...'
          : dataString;
      buffer.writeln('Data: $truncated');
    }

    debugPrint(buffer.toString().trim());
  }

  void _logError(DioException error) {
    final buffer = StringBuffer()
      ..writeln('=== API Error ===')
      ..writeln('Type: ${error.type}')
      ..writeln('URL: ${error.requestOptions.uri}');

    if (error.response != null) {
      buffer.writeln('Status: ${error.response?.statusCode}');
      buffer.writeln('Data: ${error.response?.data}');
    } else if (error.error != null) {
      buffer.writeln('Error: ${error.error}');
    } else {
      buffer.writeln('Message: ${error.message}');
    }

    debugPrint(buffer.toString().trim());
  }
}

/// Interceptor for adding common query parameters to all requests.
class CommonQueryInterceptor extends Interceptor {
  const CommonQueryInterceptor(this.commonParameters);

  final Map<String, dynamic> commonParameters;

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) {
    if (commonParameters.isNotEmpty) {
      options.queryParameters = {
        ...commonParameters,
        ...options.queryParameters,
      };
    }
    handler.next(options);
  }
}
