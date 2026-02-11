import 'package:flutter/material.dart';
import 'package:flutter_practice/core/models/models.dart';
import 'package:flutter_practice/utils/utils.dart';

/// Product list item widget for vertical list display.
class ProductListItem extends StatelessWidget {
  const ProductListItem({required this.product, super.key});

  final Product product;

  static const double _imageSize = 80.0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              product.imageUrl,
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
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                if (product.price != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    '\$${product.price!.toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
