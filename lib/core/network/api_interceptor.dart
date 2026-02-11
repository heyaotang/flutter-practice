import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// Combined interceptor for logging, auth, and response handling.
class ApiInterceptor extends Interceptor {
  ApiInterceptor({
    this.enableLogging = kDebugMode,
    this.getToken,
    this.extractData = true,
  });

  final bool enableLogging;
  final String? Function()? getToken;
  final bool extractData;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Add auth token if available.
    final token = getToken?.call();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    // Log request.
    if (enableLogging) {
      _logRequest(options);
    }

    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // Extract data from common response format.
    if (extractData && response.data is Map<String, dynamic>) {
      final data = response.data as Map<String, dynamic>;
      if (data.containsKey('data')) {
        response.data = data['data'];
      }
    }

    // Log response.
    if (enableLogging) {
      _logResponse(response);
    }

    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Log error.
    if (enableLogging) {
      _logError(err);
    }

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
      if (dataString.length > 1000) {
        buffer.writeln('Data: ${dataString.substring(0, 1000)}...');
      } else {
        buffer.writeln('Data: $dataString');
      }
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
