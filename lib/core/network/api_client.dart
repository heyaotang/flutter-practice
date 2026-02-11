import 'package:dio/dio.dart';
import 'api_config.dart';
import 'api_exception.dart';
import 'api_interceptor.dart';

/// Enterprise-grade HTTP client based on Dio.
class ApiClient {
  ApiClient._({
    required this.dio,
  });

  /// Creates a new [ApiClient] instance.
  factory ApiClient.create({
    String? baseUrl,
    Duration? connectTimeout,
    Duration? receiveTimeout,
    Duration? sendTimeout,
    Map<String, String>? headers,
    bool enableLogging = true,
    String? Function()? getToken,
    bool extractData = true,
    List<Interceptor>? additionalInterceptors,
  }) {
    final baseOptions = ApiConfig.dioOptions;

    // Apply custom overrides.
    if (baseUrl != null) {
      baseOptions.baseUrl = baseUrl;
    }
    if (connectTimeout != null) {
      baseOptions.connectTimeout = connectTimeout;
    }
    if (receiveTimeout != null) {
      baseOptions.receiveTimeout = receiveTimeout;
    }
    if (sendTimeout != null) {
      baseOptions.sendTimeout = sendTimeout;
    }
    if (headers != null) {
      baseOptions.headers.addAll(headers);
    }

    final dio = Dio(baseOptions);

    // Add main interceptor.
    dio.interceptors.add(
      ApiInterceptor(
        enableLogging: enableLogging,
        getToken: getToken,
        extractData: extractData,
      ),
    );

    // Add additional interceptors if provided.
    if (additionalInterceptors != null) {
      dio.interceptors.addAll(additionalInterceptors);
    }

    return ApiClient._(dio: dio);
  }

  final Dio dio;

  /// Returns the underlying Dio instance for advanced usage.
  Dio get client => dio;

  // ========== HTTP Methods ==========

  /// Performs a GET request.
  Future<T> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
    T Function(dynamic data)? decoder,
  }) async {
    try {
      final response = await dio.get(
        path,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );
      return decoder != null ? decoder(response.data) : response.data as T;
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  /// Performs a POST request.
  Future<T> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
    T Function(dynamic data)? decoder,
  }) async {
    try {
      final response = await dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return decoder != null ? decoder(response.data) : response.data as T;
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  /// Performs a PUT request.
  Future<T> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
    T Function(dynamic data)? decoder,
  }) async {
    try {
      final response = await dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return decoder != null ? decoder(response.data) : response.data as T;
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  /// Performs a PATCH request.
  Future<T> patch<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
    T Function(dynamic data)? decoder,
  }) async {
    try {
      final response = await dio.patch(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return decoder != null ? decoder(response.data) : response.data as T;
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  /// Performs a DELETE request.
  Future<T> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    T Function(dynamic data)? decoder,
  }) async {
    try {
      final response = await dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return decoder != null ? decoder(response.data) : response.data as T;
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  /// Downloads a file.
  Future<String> download(
    String urlPath,
    String savePath, {
    ProgressCallback? onReceiveProgress,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    bool deleteOnError = true,
    String lengthHeader = Headers.contentLengthHeader,
    dynamic data,
  }) async {
    try {
      await dio.download(
        urlPath,
        savePath,
        onReceiveProgress: onReceiveProgress,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        deleteOnError: deleteOnError,
        lengthHeader: lengthHeader,
        data: data,
      );
      return savePath;
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  // ========== Utility Methods ==========

  /// Creates a cancel token for cancelling requests.
  CancelToken createCancelToken() => CancelToken();

  /// Updates the base URL.
  void updateBaseUrl(String baseUrl) {
    dio.options.baseUrl = baseUrl;
  }

  /// Updates the default headers.
  void updateHeaders(Map<String, String> headers) {
    dio.options.headers.addAll(headers);
  }

  /// Clears all headers.
  void clearHeaders() {
    dio.options.headers.clear();
  }
}
