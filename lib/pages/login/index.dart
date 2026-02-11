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
      body: const Center(
        child: _LoginContent(),
      ),
    );
  }
}

class _LoginContent extends StatelessWidget {
  const _LoginContent();

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        PagePlaceholder(title: LoginPage.title),
        SizedBox(height: AppConstants.spacingLarge),
        _BackButton(),
      ],
    );
  }
}

class _BackButton extends StatelessWidget {
  const _BackButton();

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => Navigator.pop(context),
      child: const Text('Back'),
    );
  }
}
