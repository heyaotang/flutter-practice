import 'package:flutter/material.dart';
import 'package:flutter_practice/core/widgets/page_placeholder.dart';

/// Page displayed when a route is not found.
class NotFoundPage extends StatelessWidget {
  const NotFoundPage({super.key});

  static const String title = '404 - Page Not Found';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Not Found'),
      ),
      body: const PlaceholderPage(title: title),
    );
  }
}
