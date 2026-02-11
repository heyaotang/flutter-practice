import 'package:flutter/widgets.dart';
import 'package:flutter_practice/components/home/components.dart';
import 'package:flutter_practice/utils/mock_data_generator.dart';

/// Home hot items component with 2x2 grid.
class HomeHots extends StatelessWidget {
  const HomeHots({super.key});

  static const int _hotCount = 4;

  @override
  Widget build(BuildContext context) {
    final products = MockDataGenerator.getProducts(
      count: _hotCount,
      startId: 10,
    );

    return ProductGrid(products: products);
  }
}
