import 'package:flutter/widgets.dart';
import 'package:flutter_practice/core/widgets/page_placeholder.dart';

/// Messages page for user notifications and chats.
class MessagesPage extends StatelessWidget {
  const MessagesPage({super.key});

  static const String title = 'Messages Page';
  static const String subtitle = 'View your notifications and messages';

  @override
  Widget build(BuildContext context) {
    return const PlaceholderPage(
      title: title,
      subtitle: subtitle,
    );
  }
}
