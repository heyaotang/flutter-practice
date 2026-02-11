import 'package:freezed_annotation/freezed_annotation.dart';

part 'banner.freezed.dart';
part 'banner.g.dart';

/// Represents a banner image for the home page carousel.
///
/// Note: Named `BannerData` to avoid conflict with Material's `Banner` widget.
@freezed
class BannerData with _$BannerData {
  const BannerData._();

  const factory BannerData({
    required String id,
    required String image,
  }) = _BannerData;

  factory BannerData.fromJson(Map<String, dynamic> json) =>
      _$BannerDataFromJson(json);
}
