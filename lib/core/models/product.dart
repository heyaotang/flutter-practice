import 'package:freezed_annotation/freezed_annotation.dart';

part 'product.freezed.dart';
part 'product.g.dart';

/// Represents a product in the e-commerce catalog.
///
/// This model uses freezed for immutability, code generation,
/// and JSON serialization following the clean architecture pattern.
@freezed
class Product with _$Product {
  const Product._();

  const factory Product({
    required String id,
    required String name,
    required String image,
    required double price,
  }) = _Product;

  /// Creates a Product from JSON data.
  factory Product.fromJson(Map<String, dynamic> json) =>
      _$ProductFromJson(json);
}
