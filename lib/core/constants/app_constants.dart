import 'package:flutter/material.dart';

/// App-wide constants for consistent styling and behavior.
class AppConstants {
  AppConstants._();

  static const String appName = 'Flutter Practice';
  static const Color primarySeedColor = Colors.deepPurple;

  static const double spacingSmall = 8.0;
  static const double spacingMedium = 16.0;
  static const double spacingLarge = 24.0;
  static const double spacingXLarge = 32.0;

  static const double fontSizeTitle = 24.0;
  static const double fontSizeBody = 16.0;
  static const double fontSizeCaption = 14.0;

  static const List<String> tabTitles = [
    'Home',
    'Categories',
    'Messages',
    'Profile',
  ];

  static const int homeTabIndex = 0;
  static const int categoriesTabIndex = 1;
  static const int messagesTabIndex = 2;
  static const int profileTabIndex = 3;

  static const IconData homeIcon = Icons.home_outlined;
  static const IconData homeIconActive = Icons.home;
  static const IconData categoriesIcon = Icons.category_outlined;
  static const IconData categoriesIconActive = Icons.category;
  static const IconData messagesIcon = Icons.message_outlined;
  static const IconData messagesIconActive = Icons.message;
  static const IconData profileIcon = Icons.person_outline;
  static const IconData profileIconActive = Icons.person;

  static const double bannerHeight = 300.0;
  static const Duration bannerAutoPlayInterval = Duration(seconds: 3);
  static const double categoriesHeight = 100.0;
  static const double categoryItemSize = 80.0;
  static const int productBatchSize = 10;
  static const double scrollLoadThreshold = 200.0;

  static const int productPageSize = 20;
  static const double scrollLoadThresholdNear = 50.0;
  static const int totalProducts = 102;
}
