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

    return SizedBox(
      height: AppConstants.categoriesHeight,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return _CategoryItem(category: category);
        },
      ),
    );
  }
}

class _CategoryItem extends StatelessWidget {
  const _CategoryItem({required this.category});

  final Category category;

  static const double iconSize = 32.0;
  static const double spacing = 8.0;

  @override
  Widget build(BuildContext context) {
    const itemSize = AppConstants.categoryItemSize;

    return Padding(
      padding: const EdgeInsets.only(right: 16),
      child: SizedBox(
        width: itemSize,
        height: itemSize,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              category.icon,
              size: iconSize,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: spacing),
            Text(
              category.name,
              style: Theme.of(context).textTheme.labelSmall,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
