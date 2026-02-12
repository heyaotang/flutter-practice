import 'package:flutter/material.dart';
import 'package:flutter_practice/features/auth/data/repositories/auth_repository.dart';
import 'package:flutter_practice/features/auth/data/services/auth_storage_service.dart';
import 'package:flutter_practice/features/auth/presentation/providers/auth_provider.dart';
import 'package:flutter_practice/pages/navigations/index.dart';
import 'package:flutter_practice/providers/navigation_provider.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

class MockStorageService extends Mock implements AuthStorageService {}

void main() {
  late MockAuthRepository mockAuthRepository;
  late MockStorageService mockStorageService;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    mockStorageService = MockStorageService();

    // Setup default mock behaviors
    when(() => mockAuthRepository.getStoredToken())
        .thenAnswer((_) async => null);
    when(() => mockStorageService.getToken()).thenReturn(null);
  });

  group('App Routing Tests', () {
    testWidgets('Home page displays correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(
              create: (_) => NavigationProvider(),
            ),
            ChangeNotifierProvider(
              create: (_) => AuthProvider(repository: mockAuthRepository),
            ),
          ],
          child: const MaterialApp(
            home: NavigationsPage(),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.text('Home'), findsWidgets);
    });
  });
}
