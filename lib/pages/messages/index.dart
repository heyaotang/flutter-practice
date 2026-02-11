import 'package:flutter/material.dart';
import 'package:flutter_practice/core/widgets/page_placeholder.dart';

/// Messages page for user notifications and chats.
class MessagesPage extends StatelessWidget {
  const MessagesPage({super.key});

  static const String title = 'Messages Page';
  static const String subtitle = 'View your notifications and messages';

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
