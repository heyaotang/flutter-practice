/// Product model for e-commerce items.
class Product {
  const Product({
    required this.id,
    required this.name,
    required this.imageUrl,
    this.price,
  });

  final String id;
  final String name;
  final String imageUrl;
  final double? price;
}
