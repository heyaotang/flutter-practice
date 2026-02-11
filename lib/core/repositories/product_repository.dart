import 'package:flutter/foundation.dart';
import 'package:flutter_practice/core/models/models.dart';
import 'package:flutter_practice/core/network/network.dart';

class ProductRepository {
  ProductRepository({ApiClient? apiClient})
      : _apiClient = apiClient ?? ApiClient.create();

  final ApiClient _apiClient;

  static const ProductResponse _emptyResponse = ProductResponse(
    products: [],
    total: 0,
    hasMore: false,
  );

  Future<ProductResponse> getProducts({
    required int offset,
    required int limit,
  }) async {
    try {
      final response = await _apiClient.post(
        '/get-products',
        data: {'offset': offset, 'limit': limit},
      );

      if (response is! Map<String, dynamic>) {
        debugPrint('Invalid response type: ${response.runtimeType}');
        return _emptyResponse;
      }

      return ProductResponse.fromJson(response);
    } catch (error) {
      debugPrint('Failed to load products: $error');
      return _emptyResponse;
    }
  }
}
