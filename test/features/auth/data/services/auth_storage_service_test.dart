import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_practice/features/auth/data/services/auth_storage_service.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late MockSharedPreferences mockPrefs;
  late AuthStorageService storageService;

  setUp(() {
    mockPrefs = MockSharedPreferences();
    storageService = AuthStorageService(mockPrefs);
  });

  group('AuthStorageService', () {
    test('saveToken stores token correctly', () async {
      when(() => mockPrefs.setString('auth_token', 'test_token'))
          .thenAnswer((_) async => true);

      await storageService.saveToken('test_token');

      verify(() => mockPrefs.setString('auth_token', 'test_token')).called(1);
    });

    test('getToken returns stored token', () {
      when(() => mockPrefs.getString('auth_token')).thenReturn('test_token');

      final token = storageService.getToken();

      expect(token, equals('test_token'));
    });

    test('getToken returns null when no token stored', () {
      when(() => mockPrefs.getString('auth_token')).thenReturn(null);

      final token = storageService.getToken();

      expect(token, isNull);
    });

    test('clearToken removes token from storage', () async {
      when(() => mockPrefs.remove('auth_token')).thenAnswer((_) async => true);

      await storageService.clearToken();

      verify(() => mockPrefs.remove('auth_token')).called(1);
    });
  });
}
