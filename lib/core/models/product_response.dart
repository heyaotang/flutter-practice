import 'package:flutter_practice/core/models/product.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'product_response.freezed.dart';
part 'product_response.g.dart';

@freezed
class ProductResponse with _$ProductResponse {
  const ProductResponse._();

  const factory ProductResponse({
    required List<Product> products,
    required int total,
    required bool hasMore,
  }) = _ProductResponse;

  factory ProductResponse.fromJson(Map<String, dynamic> json) =>
      _$ProductResponseFromJson(json);
}
