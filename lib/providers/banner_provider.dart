import 'package:flutter/foundation.dart';
import 'package:flutter_practice/core/models/banner.dart';
import 'package:flutter_practice/core/repositories/banner_repository.dart';

/// State management for banner data using ChangeNotifier pattern.
class BannerProvider extends ChangeNotifier {
  BannerProvider({BannerRepository? repository})
      : _repository = repository ?? BannerRepository();

  final BannerRepository _repository;

  static const String _errorMessage = 'Failed to load banners';

  List<BannerData> _banners = [];
  bool _isLoading = false;
  String? _error;

  List<BannerData> get banners => List.unmodifiable(_banners);
  bool get isLoading => _isLoading;
  String? get errorMessage => _error;
  bool get hasError => _error != null;
  bool get hasBanners => _banners.isNotEmpty;

  /// Fetches banners from the repository and updates state.
  Future<void> fetchBanners() async {
    _setLoading(true);
    _clearError();

    try {
      _banners = await _repository.getBanners();
    } catch (error) {
      _setError(error);
      _banners = [];
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
  }

  void _setError(Object error) {
    _error = _errorMessage;
    debugPrint('Error fetching banners: $error');
  }
}
