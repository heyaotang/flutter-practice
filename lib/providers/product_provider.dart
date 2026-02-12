import 'package:flutter/foundation.dart';
import 'package:flutter_practice/core/models/models.dart';
import 'package:flutter_practice/core/repositories/product_repository.dart';

class ProductProvider extends ChangeNotifier {
  ProductProvider({ProductRepository? repository})
      : _repository = repository ?? ProductRepository();

  final ProductRepository _repository;

  final List<Product> _products = [];
  bool _isLoading = false;
  String? _errorMessage;
  bool _hasMore = true;
  int _offset = 0;
  bool _isRefreshing = false;
  bool _allowInternalLoad = false;

  List<Product> get products => List.unmodifiable(_products);
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get hasError => _errorMessage != null;
  bool get hasMore => _hasMore;
  bool get isRefreshing => _isRefreshing;

  static const int _pageSize = 20;
  static const String _loadErrorMessage =
      'Failed to load products. Tap to retry.';

  Future<void> loadMore() async {
    if (_isLoading || (!_hasMore && _errorMessage == null)) return;
    if (_isRefreshing && !_allowInternalLoad) return;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _repository.getProducts(
        offset: _offset,
        limit: _pageSize,
      );

      _products.addAll(response.products);
      _offset += response.products.length;

      if (response.products.isEmpty || response.products.length < _pageSize) {
        _hasMore = false;
      }
    } catch (error) {
      _errorMessage = _loadErrorMessage;
      debugPrint('Error loading products: $error');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> retry() => loadMore();

  void reset() {
    _products.clear();
    _errorMessage = null;
    _hasMore = true;
    _offset = 0;
    notifyListeners();
  }

  /// Refresh product list from scratch.
  /// Clears existing data and reloads first page.
  Future<void> refresh() async {
    _isRefreshing = true;
    _allowInternalLoad = true;
    notifyListeners();
    try {
      reset();
      await loadMore();
    } finally {
      _isRefreshing = false;
      _allowInternalLoad = false;
      notifyListeners();
    }
  }
}
