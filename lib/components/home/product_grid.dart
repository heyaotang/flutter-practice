import 'package:flutter/material.dart';
import 'package:flutter_practice/components/home/components.dart';
import 'package:flutter_practice/core/models/models.dart';

/// Reusable product grid component with 2x2 layout.
class ProductGrid extends StatelessWidget {
  const ProductGrid({
    required this.products,
    super.key,
  });

  final List<Product> products;

  static const double _spacing = 16.0;
  static const int _crossAxisCount = 2;

  static const _gridDelegate = SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: _crossAxisCount,
    mainAxisSpacing: _spacing,
    crossAxisSpacing: _spacing,
    childAspectRatio: 1,
  );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: _spacing),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: _gridDelegate,
        itemCount: products.length,
        itemBuilder: (context, index) => ProductCard(
          product: products[index],
        ),
      ),
    );
  }
}
