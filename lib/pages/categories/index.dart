import 'package:flutter/material.dart';
import 'package:flutter_practice/core/widgets/page_placeholder.dart';

/// Categories page for browsing content categories.
class CategoriesPage extends StatelessWidget {
  const CategoriesPage({super.key});

  static const String title = 'Categories Page';
  static const String subtitle = 'Browse content by category';

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: PagePlaceholder(
          title: title,
          subtitle: subtitle,
        ),
      ),
    );
  }
}
