import 'package:flutter/material.dart';
import 'package:flutter_practice/components/home/components.dart';
import 'package:flutter_practice/core/constants/app_constants.dart';
import 'package:flutter_practice/core/models/models.dart';
import 'package:flutter_practice/utils/mock_data_generator.dart';

/// Home products component with infinite scroll and load more.
class HomeProducts extends StatefulWidget {
  const HomeProducts({super.key});

  @override
  State<HomeProducts> createState() => _HomeProductsState();
}

class _HomeProductsState extends State<HomeProducts> {
  final ScrollController _scrollController = ScrollController();
  final List<Product> _products = [];
  bool _isLoading = false;
  int _currentStartId = 20;

  @override
  void initState() {
    super.initState();
    _loadMoreProducts(isInitial: true);
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isLoading) return;

    final position = _scrollController.position;
    if (position.pixels >=
        position.maxScrollExtent - AppConstants.scrollLoadThreshold) {
      _loadMoreProducts();
    }
  }

  Future<void> _loadMoreProducts({bool isInitial = false}) async {
    if (_isLoading) return;

    setState(() => _isLoading = true);

    await Future.delayed(const Duration(milliseconds: 500));

    if (!mounted) return;

    final newProducts = MockDataGenerator.getProducts(
      count: AppConstants.productBatchSize,
      startId: _currentStartId,
    );

    setState(() {
      _products.addAll(newProducts);
      _currentStartId += AppConstants.productBatchSize;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListView.builder(
          controller: _scrollController,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _products.length,
          itemBuilder: (context, index) {
            return ProductListItem(product: _products[index]);
          },
        ),
        if (_isLoading) const LoadingIndicator(),
      ],
    );
  }
}
