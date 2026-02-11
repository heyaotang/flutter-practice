import 'package:flutter/material.dart';

/// Helper functions for image widgets.
class ImageHelpers {
  ImageHelpers._();

  /// Standard error builder for network images.
  static Widget Function(BuildContext, Object, StackTrace?) buildErrorBuilder({
    double iconSize = 32,
    double? width,
    double? height,
  }) {
    return (_, __, ___) {
      return Container(
        width: width,
        height: height,
        color: Colors.grey[300],
        child: Center(
          child: Icon(Icons.broken_image, size: iconSize),
        ),
      );
    };
  }
}
