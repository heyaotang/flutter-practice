// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ProductResponseImpl _$$ProductResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$ProductResponseImpl(
      products: (json['products'] as List<dynamic>)
          .map((e) => Product.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: (json['total'] as num).toInt(),
      hasMore: json['hasMore'] as bool,
    );

Map<String, dynamic> _$$ProductResponseImplToJson(
        _$ProductResponseImpl instance) =>
    <String, dynamic>{
      'products': instance.products,
      'total': instance.total,
      'hasMore': instance.hasMore,
    };
