import 'package:flutter/material.dart';
import 'package:flutter_practice/core/constants/app_constants.dart';
import 'package:flutter_practice/features/auth/data/repositories/auth_repository.dart';
import 'package:flutter_practice/features/auth/data/services/auth_storage_service.dart';
import 'package:flutter_practice/features/auth/presentation/providers/auth_provider.dart';
import 'package:flutter_practice/core/network/api_client.dart';
import 'package:flutter_practice/providers/navigation_provider.dart';
import 'package:flutter_practice/routes/index.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  final storageService = AuthStorageService(prefs);
  final apiClient = ApiClient.create(
    getToken: storageService.getToken,
  );
  final authRepository = AuthRepository(
    apiClient: apiClient,
    storageService: storageService,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => NavigationProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => AuthProvider(repository: authRepository)..initialize(),
        ),
      ],
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
