import 'package:flutter/material.dart';
import 'package:flutter_practice/core/constants/app_constants.dart';
import 'package:flutter_practice/core/widgets/page_placeholder.dart';

/// Login page for user authentication.
class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  static const String title = 'Login Page';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const PagePlaceholder(title: title),
            const SizedBox(height: AppConstants.spacingLarge),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Back'),
            ),
          ],
        ),
      ),
    );
  }
}
