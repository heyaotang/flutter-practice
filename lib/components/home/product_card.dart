import 'package:flutter/material.dart';
import 'package:flutter_practice/core/models/models.dart';
import 'package:flutter_practice/utils/utils.dart';

/// Product card widget for grid display.
class ProductCard extends StatelessWidget {
  const ProductCard({required this.product, super.key});

  final Product product;

  static const double _borderRadius = 8.0;
  static const double _spacing = 8.0;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(_borderRadius),
            child: Image.network(
              product.image,
              fit: BoxFit.cover,
              errorBuilder: ImageHelpers.buildErrorBuilder(),
            ),
          ),
        ),
        const SizedBox(height: _spacing),
        Text(
          product.name,
          style: Theme.of(context).textTheme.bodySmall,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
