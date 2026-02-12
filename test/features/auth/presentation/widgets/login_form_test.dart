import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_practice/features/auth/presentation/widgets/login_form.dart';

void main() {
  group('LoginForm validation', () {
    testWidgets('shows error when username is empty', (tester) async {
      await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: LoginForm(onLogin: (_, __) async {}))),
      );

      // First enter some text to trigger validation
      final usernameField = find.byKey(const Key('username_field'));
      await tester.enterText(usernameField, 'test');
      await tester.pump();

      // Clear the text to trigger empty validation
      await tester.enterText(usernameField, '');
      await tester.pump();

      expect(find.text('Please enter username'), findsOneWidget);
    });

    testWidgets('shows error when username contains non-English characters',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: LoginForm(onLogin: (_, __) async {}))),
      );

      final usernameField = find.byKey(const Key('username_field'));
      await tester.enterText(usernameField, '用户名');
      await tester.pump();

      expect(find.text('Username must be English only'), findsOneWidget);
    });

    testWidgets('shows error when username contains numbers', (tester) async {
      await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: LoginForm(onLogin: (_, __) async {}))),
      );

      final usernameField = find.byKey(const Key('username_field'));
      await tester.enterText(usernameField, 'user123');
      await tester.pump();

      expect(find.text('Username must be English only'), findsOneWidget);
    });

    testWidgets('shows no error when username is valid', (tester) async {
      await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: LoginForm(onLogin: (_, __) async {}))),
      );

      final usernameField = find.byKey(const Key('username_field'));
      await tester.enterText(usernameField, 'Username');
      await tester.pump();

      expect(
        find.text('Username must be English only'),
        findsNothing,
      );
      expect(
        find.text('Please enter username'),
        findsNothing,
      );
    });

    testWidgets('shows error when password is empty', (tester) async {
      await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: LoginForm(onLogin: (_, __) async {}))),
      );

      final passwordField = find.byKey(const Key('password_field'));
      await tester.enterText(passwordField, 'test');
      await tester.pump();

      await tester.enterText(passwordField, '');
      await tester.pump();

      expect(find.text('Password required'), findsOneWidget);
    });

    testWidgets('shows error when password contains non-English characters',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: LoginForm(onLogin: (_, __) async {}))),
      );

      final passwordField = find.byKey(const Key('password_field'));
      await tester.enterText(passwordField, '密码123');
      await tester.pump();

      expect(find.text('Password must be English only'), findsOneWidget);
    });

    testWidgets('shows error when password contains numbers', (tester) async {
      await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: LoginForm(onLogin: (_, __) async {}))),
      );

      final passwordField = find.byKey(const Key('password_field'));
      await tester.enterText(passwordField, 'pass123');
      await tester.pump();

      expect(find.text('Password must be English only'), findsOneWidget);
    });

    testWidgets('shows no error when password is valid', (tester) async {
      await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: LoginForm(onLogin: (_, __) async {}))),
      );

      final passwordField = find.byKey(const Key('password_field'));
      await tester.enterText(passwordField, 'Password');
      await tester.pump();

      expect(
        find.text('Password must be English only'),
        findsNothing,
      );
      expect(
        find.text('Password required'),
        findsNothing,
      );
    });
  });

  group('LoginForm integration', () {
    testWidgets('shows loading state during login', (tester) async {
      bool loginCalled = false;
      final completer = Completer<void>();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LoginForm(
              onLogin: (_, __) async {
                loginCalled = true;
                await completer.future;
              },
            ),
          ),
        ),
      );

      // Fill in valid credentials
      await tester.enterText(
        find.byKey(const Key('username_field')),
        'ValidUser',
      );
      await tester.enterText(
        find.byKey(const Key('password_field')),
        'ValidPass',
      );
      await tester.pump();

      // Tap login button
      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      // Verify loading indicator is shown
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(loginCalled, isTrue);

      // Complete the login
      completer.complete();
      await tester.pump();
    });

    testWidgets('navigates back on successful login', (tester) async {
      bool navigated = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LoginForm(
              onLogin: (_, __) async {
                // Simulate successful login
              },
            ),
          ),
          onGenerateRoute: (settings) {
            if (settings.name == '/') {
              return MaterialPageRoute(
                builder: (_) => Scaffold(
                  body: LoginForm(
                    onLogin: (_, __) async {
                      // Simulate successful login
                    },
                  ),
                ),
              );
            }
            return null;
          },
          navigatorObservers: [
            _MockNavigatorObserver(
              onPop: () => navigated = true,
            ),
          ],
        ),
      );

      // Fill in valid credentials
      await tester.enterText(
        find.byKey(const Key('username_field')),
        'ValidUser',
      );
      await tester.enterText(
        find.byKey(const Key('password_field')),
        'ValidPass',
      );
      await tester.pump();

      // Tap login button
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      // Verify navigation occurred
      expect(navigated, isTrue);
    });

    testWidgets('shows error dialog on login failure', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LoginForm(
              onLogin: (_, __) async {
                throw Exception('Invalid credentials');
              },
            ),
          ),
        ),
      );

      // Fill in valid credentials
      await tester.enterText(
        find.byKey(const Key('username_field')),
        'ValidUser',
      );
      await tester.enterText(
        find.byKey(const Key('password_field')),
        'ValidPass',
      );
      await tester.pump();

      // Tap login button
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      // Verify error dialog is shown
      expect(find.text('Login Failed'), findsOneWidget);
      expect(find.text('Exception: Invalid credentials'), findsOneWidget);
      expect(find.text('OK'), findsOneWidget);
    });

    testWidgets('disables button when form is invalid', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LoginForm(
              onLogin: (_, __) async {},
            ),
          ),
        ),
      );

      final button = find.byType(ElevatedButton);

      // Button should be disabled initially
      expect(tester.widget<ElevatedButton>(button).enabled, isFalse);

      // Fill in only username (invalid form)
      await tester.enterText(
        find.byKey(const Key('username_field')),
        'ValidUser',
      );
      await tester.pump();

      expect(tester.widget<ElevatedButton>(button).enabled, isFalse);

      // Fill in only password (invalid form)
      await tester.enterText(find.byKey(const Key('username_field')), '');
      await tester.enterText(
        find.byKey(const Key('password_field')),
        'ValidPass',
      );
      await tester.pump();

      expect(tester.widget<ElevatedButton>(button).enabled, isFalse);

      // Fill in both fields (valid form)
      await tester.enterText(
        find.byKey(const Key('username_field')),
        'ValidUser',
      );
      await tester.pump();

      expect(tester.widget<ElevatedButton>(button).enabled, isTrue);

      // Invalid username with numbers
      await tester.enterText(
        find.byKey(const Key('username_field')),
        'User123',
      );
      await tester.pump();

      expect(tester.widget<ElevatedButton>(button).enabled, isFalse);
    });

    testWidgets('button is disabled during loading', (tester) async {
      final completer = Completer<void>();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LoginForm(
              onLogin: (_, __) async {
                await completer.future;
                throw Exception('Login error');
              },
            ),
          ),
        ),
      );

      // Fill in valid credentials
      await tester.enterText(
        find.byKey(const Key('username_field')),
        'ValidUser',
      );
      await tester.enterText(
        find.byKey(const Key('password_field')),
        'ValidPass',
      );
      await tester.pump();

      // Tap login button
      final button = find.byType(ElevatedButton);
      await tester.tap(button);
      await tester.pump();

      // Button should be disabled during loading
      expect(tester.widget<ElevatedButton>(button).enabled, isFalse);

      // Complete the login (with error to avoid navigation)
      completer.complete();
      await tester.pumpAndSettle();

      // Button should be enabled again after login completes
      expect(tester.widget<ElevatedButton>(button).enabled, isTrue);
    });
  });
}

class _MockNavigatorObserver extends NavigatorObserver {
  _MockNavigatorObserver({required this.onPop});

  final VoidCallback onPop;

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    onPop();
  }
}
