import 'package:flutter/material.dart';
import 'package:flutter_practice/features/auth/presentation/providers/auth_provider.dart';
import 'package:flutter_practice/features/auth/presentation/widgets/login_form.dart';
import 'package:provider/provider.dart';

/// Login page for user authentication.
class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  static const String title = 'Login';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(title),
      ),
      body: Consumer<AuthProvider>(
        builder: (context, auth, _) {
          return LoginForm(
            onLogin: (username, password) {
              return auth.login(username, password);
            },
          );
        },
      ),
    );
  }
}
