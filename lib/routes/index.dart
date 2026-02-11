import 'package:flutter/material.dart';
import 'package:flutter_practice/pages/login/index.dart';
import 'package:flutter_practice/pages/navigations/index.dart';
import 'package:flutter_practice/pages/not_found/index.dart';

/// App route configuration.
///
/// Defines all application routes and provides navigation helpers.
class AppRoutes {
  AppRoutes._();

  // Route paths
  static const String navigations = '/';
  static const String login = '/login';
  static const String notFound = '/not_found';

  // Route definitions
  static final Map<String, WidgetBuilder> routes = {
    navigations: (context) => const NavigationsPage(),
    login: (context) => const LoginPage(),
    notFound: (context) => const NotFoundPage(),
  };

  /// Handler for unknown routes.
  ///
  /// Returns a route to the NotFoundPage when navigation fails.
  static Route<dynamic> onUnknownRoute(RouteSettings settings) {
    return MaterialPageRoute(
      builder: (context) => const NotFoundPage(),
      settings: settings,
    );
  }
}
