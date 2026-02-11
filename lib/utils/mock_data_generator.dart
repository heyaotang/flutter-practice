import 'package:flutter/material.dart';
import 'package:flutter_practice/core/models/models.dart';

/// Mock data generator for home page components.
class MockDataGenerator {
  MockDataGenerator._();

  /// Predefined category icons for variety.
  static const List<IconData> _categoryIcons = [
    Icons.shopping_bag,
    Icons.phone_android,
    Icons.laptop,
    Icons.headphones,
    Icons.watch,
    Icons.camera,
    Icons.games,
    Icons.tv,
  ];

  /// Generates mock categories.
  static List<Category> getCategories({required int count}) {
    return List.generate(
      count,
      (index) => Category(
        id: 'cat_$index',
        name: 'Category ${index + 1}',
        icon: _categoryIcons[index % _categoryIcons.length],
      ),
    );
  }

  /// Generates mock products with sequential IDs.
  static List<Product> getProducts({
    required int count,
    required int startId,
  }) {
    return List.generate(
      count,
      (index) {
        final id = startId + index;
        return Product(
          id: 'prod_$id',
          name: 'Product $id',
          imageUrl:
              'https://placehold.co/150x150/673AB7/white?text=Product+$id',
          price: (id * 10.0 + 9.99),
        );
      },
    );
  }
}
