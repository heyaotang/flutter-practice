import 'package:flutter/material.dart';
import 'package:flutter_practice/core/constants/app_constants.dart';
import 'package:flutter_practice/core/models/models.dart';
import 'package:flutter_practice/utils/mock_data_generator.dart';

/// Home categories component with horizontal scroll.
class HomeCategories extends StatelessWidget {
  const HomeCategories({super.key});

  static const int _categoryCount = 8;

  @override
  Widget build(BuildContext context) {
    final categories = MockDataGenerator.getCategories(count: _categoryCount);
    final colorScheme = Theme.of(context).colorScheme;

    return SizedBox(
      height: AppConstants.categoriesHeight,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return Padding(
            padding: const EdgeInsets.only(right: 16),
            child: _CategoryItem(
              category: category,
              colorScheme: colorScheme,
            ),
          );
        },
      ),
    );
  }
}

class _CategoryItem extends StatelessWidget {
  const _CategoryItem({
    required this.category,
    required this.colorScheme,
  });

  final Category category;
  final ColorScheme colorScheme;

  static const double _iconSize = 32.0;
  static const double _spacing = 8.0;
  static const double _itemSize = AppConstants.categoryItemSize;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: _itemSize,
      height: _itemSize,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(category.icon, size: _iconSize, color: colorScheme.primary),
          const SizedBox(height: _spacing),
          Text(
            category.name,
            style: Theme.of(context).textTheme.labelSmall,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
