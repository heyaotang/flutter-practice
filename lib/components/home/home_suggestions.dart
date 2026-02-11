import 'package:flutter/widgets.dart';
import 'package:flutter_practice/components/home/components.dart';
import 'package:flutter_practice/utils/mock_data_generator.dart';

/// Home suggestions component with 2x2 grid.
class HomeSuggestions extends StatelessWidget {
  const HomeSuggestions({super.key});

  static const int _suggestionCount = 4;

  @override
  Widget build(BuildContext context) {
    final products = MockDataGenerator.getProducts(
      count: _suggestionCount,
      startId: 1,
    );

    return ProductGrid(products: products);
  }
}
