import 'package:dio/dio.dart';

import 'api_config.dart';
import 'api_exception.dart';
import 'api_interceptor.dart';

/// Enterprise-grade HTTP client based on Dio.
class ApiClient {
  ApiClient._({required this.dio});

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

    if (baseUrl != null) baseOptions.baseUrl = baseUrl;
    if (connectTimeout != null) baseOptions.connectTimeout = connectTimeout;
    if (receiveTimeout != null) baseOptions.receiveTimeout = receiveTimeout;
    if (sendTimeout != null) baseOptions.sendTimeout = sendTimeout;
    if (headers != null) baseOptions.headers.addAll(headers);

    final dio = Dio(baseOptions);
    dio.interceptors.add(
      ApiInterceptor(
        enableLogging: enableLogging,
        getToken: getToken,
        extractData: extractData,
      ),
    );

    if (additionalInterceptors != null) {
      dio.interceptors.addAll(additionalInterceptors);
    }

    return ApiClient._(dio: dio);
  }

  final Dio dio;

  Dio get client => dio;

  Future<T> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
    T Function(dynamic data)? decoder,
  }) =>
      _request<T>(
        () => dio.get(
          path,
          queryParameters: queryParameters,
          options: options,
          cancelToken: cancelToken,
          onReceiveProgress: onReceiveProgress,
        ),
        decoder,
      );

  Future<T> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
    T Function(dynamic data)? decoder,
  }) =>
      _request<T>(
        () => dio.post(
          path,
          data: data ?? {},
          queryParameters: queryParameters,
          options: options,
          cancelToken: cancelToken,
          onSendProgress: onSendProgress,
          onReceiveProgress: onReceiveProgress,
        ),
        decoder,
      );

  Future<T> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
    T Function(dynamic data)? decoder,
  }) =>
      _request<T>(
        () => dio.put(
          path,
          data: data,
          queryParameters: queryParameters,
          options: options,
          cancelToken: cancelToken,
          onSendProgress: onSendProgress,
          onReceiveProgress: onReceiveProgress,
        ),
        decoder,
      );

  Future<T> patch<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
    T Function(dynamic data)? decoder,
  }) =>
      _request<T>(
        () => dio.patch(
          path,
          data: data,
          queryParameters: queryParameters,
          options: options,
          cancelToken: cancelToken,
          onSendProgress: onSendProgress,
          onReceiveProgress: onReceiveProgress,
        ),
        decoder,
      );

  Future<T> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    T Function(dynamic data)? decoder,
  }) =>
      _request<T>(
        () => dio.delete(
          path,
          data: data,
          queryParameters: queryParameters,
          options: options,
          cancelToken: cancelToken,
        ),
        decoder,
      );

  Future<T> _request<T>(
    Future<Response> Function() request,
    T Function(dynamic)? decoder,
  ) async {
    try {
      final response = await request();
      return decoder != null ? decoder(response.data) : response.data as T;
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

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

  CancelToken createCancelToken() => CancelToken();

  void updateBaseUrl(String baseUrl) {
    dio.options.baseUrl = baseUrl;
  }

  void updateHeaders(Map<String, String> headers) {
    dio.options.headers.addAll(headers);
  }

  void clearHeaders() {
    dio.options.headers.clear();
  }
}
