import 'package:flutter/material.dart';
import 'package:flutter_practice/core/constants/app_constants.dart';

/// Reusable placeholder content for pages under development.
///
/// Displays a title and optional subtitle with consistent styling.
class PagePlaceholder extends StatelessWidget {
  const PagePlaceholder({
    super.key,
    required this.title,
    this.subtitle,
  });

  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: AppConstants.fontSizeTitle),
        ),
        if (subtitle != null) ...[
          const SizedBox(height: AppConstants.spacingMedium),
          Text(
            subtitle!,
            style: const TextStyle(fontSize: AppConstants.fontSizeBody),
          ),
        ],
      ],
    );
  }
}
