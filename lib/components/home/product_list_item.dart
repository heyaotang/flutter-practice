import 'package:flutter/material.dart';
import 'package:flutter_practice/core/models/models.dart';
import 'package:flutter_practice/utils/utils.dart';

/// Product list item widget for vertical list display.
class ProductListItem extends StatelessWidget {
  const ProductListItem({required this.product, super.key});

  final Product product;

  static const double _imageSize = 80.0;
  static const double _spacing = 16.0;
  static const double _verticalSpacing = 8.0;
  static const double _namePriceSpacing = 4.0;
  static const double _borderRadius = 8.0;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: _verticalSpacing,
        horizontal: _spacing,
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(_borderRadius),
            child: Image.network(
              product.image,
              width: _imageSize,
              height: _imageSize,
              fit: BoxFit.cover,
              errorBuilder: ImageHelpers.buildErrorBuilder(
                iconSize: 24,
                width: _imageSize,
                height: _imageSize,
              ),
            ),
          ),
          const SizedBox(width: _spacing),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(product.name, style: textTheme.titleSmall),
                const SizedBox(height: _namePriceSpacing),
                Text(
                  '\$${product.price.toStringAsFixed(2)}',
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
