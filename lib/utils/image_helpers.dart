import 'package:flutter/material.dart';

/// Helper functions for image widgets.
class ImageHelpers {
  ImageHelpers._();

  static const double _defaultIconSize = 32.0;

  /// Standard error builder for network images.
  static Widget Function(BuildContext, Object, StackTrace?) buildErrorBuilder({
    double iconSize = _defaultIconSize,
    double? width,
    double? height,
  }) {
    return (_, __, ___) => Container(
          width: width,
          height: height,
          color: Colors.grey[300],
          child: Center(child: Icon(Icons.broken_image, size: iconSize)),
        );
  }
}
