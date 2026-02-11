import 'package:flutter/material.dart';
import 'package:flutter_practice/core/constants/app_constants.dart';
import 'package:flutter_practice/providers/navigation_provider.dart';
import 'package:flutter_practice/routes/index.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => NavigationProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppConstants.primarySeedColor,
        ),
        useMaterial3: true,
      ),
      initialRoute: AppRoutes.navigations,
      routes: AppRoutes.routes,
      onUnknownRoute: AppRoutes.onUnknownRoute,
    );
  }
}
