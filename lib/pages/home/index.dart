import 'package:flutter/material.dart';
import 'package:flutter_practice/core/constants/app_constants.dart';
import 'package:flutter_practice/core/widgets/page_placeholder.dart';
import 'package:flutter_practice/routes/index.dart';

/// Home page displaying main app content.
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static const String title = 'Home Page';

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: _HomeContent(),
      ),
    );
  }
}

class _HomeContent extends StatelessWidget {
  const _HomeContent();

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        PagePlaceholder(title: HomePage.title),
        SizedBox(height: AppConstants.spacingLarge),
        _LoginButton(),
      ],
    );
  }
}

class _LoginButton extends StatelessWidget {
  const _LoginButton();

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => Navigator.pushNamed(context, AppRoutes.login),
      child: const Text('Go to Login'),
    );
  }
}
