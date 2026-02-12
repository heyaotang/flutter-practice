import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_practice/features/auth/data/models/models.dart';
import 'package:flutter_practice/features/auth/data/repositories/auth_repository.dart';
import 'package:flutter_practice/core/network/api_client.dart';
import 'package:flutter_practice/features/auth/data/services/auth_storage_service.dart';

/// Mock class for [ApiClient] to use in tests.
class MockApiClient extends Mock implements ApiClient {}

/// Mock class for [AuthStorageService] to use in tests.
class MockStorageService extends Mock implements AuthStorageService {}

void main() {
  late MockApiClient mockApiClient;
  late MockStorageService mockStorageService;
  late AuthRepository repository;

  setUp(() {
    mockApiClient = MockApiClient();
    mockStorageService = MockStorageService();
    repository = AuthRepository(
      apiClient: mockApiClient,
      storageService: mockStorageService,
    );
  });

  group('AuthRepository - login', () {
    test('returns LoginResponse on successful login', () async {
      const mockResponse = LoginResponse(
        tokenType: 'Bearer',
        accessToken: 'test_access_token',
        refreshToken: 'test_refresh_token',
        expiresIn: 3600,
      );

      when(() => mockApiClient.post<Map<String, dynamic>>(
            '/login',
            data: any(named: 'data'),
          )).thenAnswer((_) async => mockResponse.toJson());

      final result = await repository.login(
        const LoginRequest(username: 'username', password: 'password'),
      );

      expect(result, equals(mockResponse));
    });
  });

  group('AuthRepository - getProfile', () {
    test('returns UserProfile on successful profile fetch', () async {
      const mockProfile = UserProfile(
        username: 'username',
        avatar: 'http://example.com/avatar.png',
      );

      when(() => mockApiClient.post<Map<String, dynamic>>(
            '/profile',
            data: any(named: 'data'),
          )).thenAnswer((_) async => mockProfile.toJson());

      final result = await repository.getProfile();

      expect(result, equals(mockProfile));
    });
  });

  group('AuthRepository - getStoredToken', () {
    test('returns token from storage', () async {
      when(() => mockStorageService.getToken()).thenReturn('stored_token');

      final token = await repository.getStoredToken();

      expect(token, equals('stored_token'));
    });
  });

  group('AuthRepository - logout', () {
    test('clears token from storage on logout', () async {
      when(() => mockStorageService.clearToken()).thenAnswer((_) async {});

      await repository.logout();

      verify(() => mockStorageService.clearToken()).called(1);
    });
  });
}
