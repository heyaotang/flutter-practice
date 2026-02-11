import 'package:flutter/material.dart';
import 'package:flutter_practice/pages/login/index.dart';
import 'package:flutter_practice/pages/navigations/index.dart';
import 'package:flutter_practice/pages/not_found/index.dart';

/// App route configuration.
class AppRoutes {
  AppRoutes._();

  static const String navigations = '/';
  static const String login = '/login';
  static const String notFound = '/not_found';

  static final Map<String, WidgetBuilder> routes = {
    navigations: (_) => const NavigationsPage(),
    login: (_) => const LoginPage(),
    notFound: (_) => const NotFoundPage(),
  };

  static Route<dynamic> onUnknownRoute(RouteSettings settings) {
    return MaterialPageRoute(
      builder: (_) => const NotFoundPage(),
      settings: settings,
    );
  }
}
