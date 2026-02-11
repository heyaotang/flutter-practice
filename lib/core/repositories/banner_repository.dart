import 'package:flutter/foundation.dart';
import 'package:flutter_practice/core/models/banner.dart';
import 'package:flutter_practice/core/network/network.dart';

/// Repository for fetching banner data from the API.
class BannerRepository {
  BannerRepository({ApiClient? apiClient})
      : _apiClient = apiClient ?? ApiClient.create();

  final ApiClient _apiClient;

  static const String _errorMessage = 'Failed to parse banner data';

  /// Fetches a list of banners from the API.
  Future<List<BannerData>> getBanners() async {
    final response = await _apiClient.post('/get-banners');

    if (response is! List) {
      debugPrint('Invalid response type: ${response.runtimeType}');
      return const [];
    }

    try {
      return response
          .map((item) =>
              item is Map<String, dynamic> ? BannerData.fromJson(item) : null)
          .whereType<BannerData>()
          .toList();
    } catch (error, stackTrace) {
      debugPrint('$_errorMessage: $error');
      debugPrint('Stack trace: $stackTrace');
      return const [];
    }
  }
}
