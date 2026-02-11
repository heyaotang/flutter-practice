import 'package:flutter/widgets.dart';
import 'package:flutter_practice/core/widgets/page_placeholder.dart';

/// Profile page for user account settings.
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  static const String title = 'Profile Page';
  static const String subtitle = 'Manage your account settings';

  @override
  Widget build(BuildContext context) {
    return const PlaceholderPage(
      title: title,
      subtitle: subtitle,
    );
  }
}
