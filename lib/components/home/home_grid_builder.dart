import 'package:flutter/widgets.dart';
import 'package:flutter_practice/components/home/components.dart';
import 'package:flutter_practice/utils/mock_data_generator.dart';

/// Builder widget for product grids with mock data.
class ProductGridBuilder extends StatelessWidget {
  const ProductGridBuilder({
    super.key,
    required this.count,
    required this.startId,
  });

  final int count;
  final int startId;

  @override
  Widget build(BuildContext context) {
    return ProductGrid(
      products: MockDataGenerator.getProducts(
        count: count,
        startId: startId,
      ),
    );
  }
}
