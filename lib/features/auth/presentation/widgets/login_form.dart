import 'package:flutter/material.dart';
import 'package:flutter_practice/core/constants/app_constants.dart';

/// Login form widget with validation.
class LoginForm extends StatefulWidget {
  const LoginForm({super.key, required this.onLogin});

  final Future<void> Function(String username, String password) onLogin;

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  bool get _isFormValid =>
      _usernameValidator(_usernameController.text) == null &&
      _passwordValidator(_passwordController.text) == null &&
      !_isLoading;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Username validation regex: only English letters (a-z, A-Z) are allowed.
  // This is per specification - usernames must be alphabetic characters only.
  String? _usernameValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter username';
    }
    final regex = RegExp(r'^[a-zA-Z]+$');
    if (!regex.hasMatch(value)) {
      return 'Username must be English only';
    }
    return null;
  }

  String? _passwordValidator(String? value) {
    // Password validation regex: only English letters (a-z, A-Z) are allowed.
    // This is per specification - passwords must be alphabetic characters only.
    if (value == null || value.isEmpty) {
      return 'Password required';
    }
    final regex = RegExp(r'^[a-zA-Z]+$');
    if (!regex.hasMatch(value)) {
      return 'Password must be English only';
    }
    return null;
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      await widget.onLogin(
        _usernameController.text,
        _passwordController.text,
      );
      if (mounted) {
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('Login Failed'),
            content: Text(e.toString()),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.lock_outline,
            size: AppConstants.loginIconSize,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(height: AppConstants.spacingLarge),
          Padding(
            padding: const EdgeInsets.all(AppConstants.spacingLarge),
            child: TextFormField(
              key: const Key('username_field'),
              controller: _usernameController,
              decoration: const InputDecoration(
                labelText: 'Username',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
              validator: _usernameValidator,
              onChanged: (_) => setState(() {}),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppConstants.spacingLarge,
            ),
            child: TextFormField(
              key: const Key('password_field'),
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.lock),
              ),
              validator: _passwordValidator,
              onChanged: (_) => setState(() {}),
            ),
          ),
          const SizedBox(height: AppConstants.spacingLarge),
          ElevatedButton(
            onPressed: _isFormValid ? _handleSubmit : null,
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(
                AppConstants.loginButtonWidth,
                AppConstants.loginButtonHeight,
              ),
            ),
            child: _isLoading
                ? const SizedBox(
                    width: AppConstants.loginButtonLoadingSize,
                    height: AppConstants.loginButtonLoadingSize,
                    child: CircularProgressIndicator(
                      strokeWidth: AppConstants.loginButtonLoadingStrokeWidth,
                    ),
                  )
                : const Text('Login'),
          ),
        ],
      ),
    );
  }
}
