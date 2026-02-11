import 'package:flutter/widgets.dart';
import 'package:flutter_practice/core/widgets/page_placeholder.dart';

/// Categories page for browsing content categories.
class CategoriesPage extends StatelessWidget {
  const CategoriesPage({super.key});

  static const String title = 'Categories Page';
  static const String subtitle = 'Browse content by category';

  @override
  Widget build(BuildContext context) {
    return const PlaceholderPage(
      title: title,
      subtitle: subtitle,
    );
  }
}
