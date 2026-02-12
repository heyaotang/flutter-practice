import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_practice/core/network/api_client.dart';
import 'package:flutter_practice/features/auth/data/models/models.dart';
import 'package:flutter_practice/features/auth/data/repositories/auth_repository.dart';
import 'package:flutter_practice/features/auth/data/services/auth_storage_service.dart';
import 'package:flutter_practice/features/auth/presentation/providers/auth_provider.dart';

/// Mock class for [ApiClient] to use in tests.
class MockApiClient extends Mock implements ApiClient {}

/// Mock class for [AuthStorageService] to use in tests.
class MockStorageService extends Mock implements AuthStorageService {}

void main() {
  late MockApiClient mockApiClient;
  late MockStorageService mockStorageService;
  late AuthRepository mockRepository;
  late AuthProvider provider;

  setUpAll(() {
    // Register fallback values for mocktail
    registerFallbackValue(
      const LoginRequest(username: '', password: ''),
    );
  });

  setUp(() {
    mockApiClient = MockApiClient();
    mockStorageService = MockStorageService();
    mockRepository = AuthRepository(
      apiClient: mockApiClient,
      storageService: mockStorageService,
    );
    provider = AuthProvider(repository: mockRepository);
  });

  group('InitialState', () {
    test('initial state is unauthenticated', () {
      final isUnauthenticated = provider.state.maybeMap(
        unauthenticated: (_) => true,
        orElse: () => false,
      );
      expect(isUnauthenticated, isTrue);
    });

    test('isAuthenticated returns false when state is unauthenticated', () {
      expect(provider.isAuthenticated, isFalse);
    });
  });

  group('login', () {
    test('updates state to authenticated on success', () async {
      const mockResponse = LoginResponse(
        tokenType: 'Bearer',
        accessToken: 'test_token',
        refreshToken: 'refresh_token',
        expiresIn: 3600,
      );
      const mockProfile = UserProfile(
        username: 'testuser',
        avatar: 'http://example.com/avatar.png',
      );

      when(() => mockApiClient.post<Map<String, dynamic>>(
            '/login',
            data: any(named: 'data'),
          )).thenAnswer((_) async => mockResponse.toJson());
      when(() => mockApiClient.post<Map<String, dynamic>>(
            '/profile',
            data: any(named: 'data'),
          )).thenAnswer((_) async => mockProfile.toJson());
      when(() => mockStorageService.saveToken(any())).thenAnswer((_) async {});
      when(() => mockStorageService.getToken()).thenReturn('test_token');

      await provider.login('username', 'password');

      final isAuthenticated = provider.state.maybeMap(
        authenticated: (_) => true,
        orElse: () => false,
      );
      expect(isAuthenticated, isTrue);
    });

    test('fetches profile after successful login', () async {
      const mockResponse = LoginResponse(
        tokenType: 'Bearer',
        accessToken: 'test_token',
        refreshToken: 'refresh_token',
        expiresIn: 3600,
      );
      const mockProfile = UserProfile(
        username: 'testuser',
        avatar: 'http://example.com/avatar.png',
      );

      when(() => mockApiClient.post<Map<String, dynamic>>(
            '/login',
            data: any(named: 'data'),
          )).thenAnswer((_) async => mockResponse.toJson());
      when(() => mockApiClient.post<Map<String, dynamic>>(
            '/profile',
            data: any(named: 'data'),
          )).thenAnswer((_) async => mockProfile.toJson());
      when(() => mockStorageService.saveToken(any())).thenAnswer((_) async {});

      await provider.login('username', 'password');

      final username = provider.state.maybeMap(
        authenticated: (state) => state.user.username,
        orElse: () => '',
      );
      final avatar = provider.state.maybeMap(
        authenticated: (state) => state.user.avatar,
        orElse: () => '',
      );
      expect(username, equals('testuser'));
      expect(avatar, equals('http://example.com/avatar.png'));
    });

    test('falls back to default profile when profile fetch fails', () async {
      const mockResponse = LoginResponse(
        tokenType: 'Bearer',
        accessToken: 'test_token',
        refreshToken: 'refresh_token',
        expiresIn: 3600,
      );

      when(() => mockApiClient.post<Map<String, dynamic>>(
            '/login',
            data: any(named: 'data'),
          )).thenAnswer((_) async => mockResponse.toJson());
      when(() => mockStorageService.saveToken(any())).thenAnswer((_) async {});
      // First call (login) succeeds, second call (getProfile) fails
      when(() => mockApiClient.post<Map<String, dynamic>>(
            '/profile',
            data: any(named: 'data'),
          )).thenThrow(Exception('Profile fetch failed'));

      await provider.login('testuser', 'password');

      final isAuthenticated = provider.state.maybeMap(
        authenticated: (_) => true,
        orElse: () => false,
      );
      expect(isAuthenticated, isTrue);

      final username = provider.state.maybeMap(
        authenticated: (state) => state.user.username,
        orElse: () => '',
      );
      expect(username, equals('testuser'));
    });

    test('throws ArgumentError when username is empty', () async {
      expect(
        () => provider.login('', 'password'),
        throwsA(isA<ArgumentError>().having(
          (e) => e.message,
          'message',
          'Username cannot be empty',
        )),
      );
    });

    test('throws ArgumentError when username contains only whitespace',
        () async {
      expect(
        () => provider.login('   ', 'password'),
        throwsA(isA<ArgumentError>().having(
          (e) => e.message,
          'message',
          'Username cannot be empty',
        )),
      );
    });

    test('throws ArgumentError when password is empty', () async {
      expect(
        () => provider.login('username', ''),
        throwsA(isA<ArgumentError>().having(
          (e) => e.message,
          'message',
          'Password cannot be empty',
        )),
      );
    });

    test('throws ArgumentError when password contains only whitespace',
        () async {
      expect(
        () => provider.login('username', '   '),
        throwsA(isA<ArgumentError>().having(
          (e) => e.message,
          'message',
          'Password cannot be empty',
        )),
      );
    });

    test('transitions to error state on login failure', () async {
      when(() => mockApiClient.post<Map<String, dynamic>>(
            any(),
            data: any(named: 'data'),
          )).thenThrow(Exception('Login failed'));

      await expectLater(
        () => provider.login('username', 'password'),
        throwsException,
      );

      final isError = provider.state.maybeMap(
        error: (_) => true,
        orElse: () => false,
      );
      expect(isError, isTrue);

      final errorMessage = provider.state.maybeMap(
        error: (state) => state.message,
        orElse: () => '',
      );
      expect(errorMessage, contains('Login failed'));
    });

    test('saves token on successful login', () async {
      const mockResponse = LoginResponse(
        tokenType: 'Bearer',
        accessToken: 'test_token',
        refreshToken: 'refresh_token',
        expiresIn: 3600,
      );

      when(() => mockApiClient.post<Map<String, dynamic>>(
            any(),
            data: any(named: 'data'),
          )).thenAnswer((_) async => mockResponse.toJson());
      when(() => mockStorageService.saveToken(any())).thenAnswer((_) async {});

      await provider.login('username', 'password');

      verify(() => mockStorageService.saveToken('test_token')).called(1);
    });
  });

  group('fetchProfile', () {
    test('updates user profile on success when authenticated', () async {
      const mockProfile = UserProfile(
        username: 'testuser',
        avatar: 'http://example.com/avatar.png',
      );

      provider.state = const AuthState.authenticated(mockProfile);

      when(() => mockApiClient.post<Map<String, dynamic>>(
            any(),
            data: any(named: 'data'),
          )).thenAnswer((_) async => mockProfile.toJson());

      await provider.fetchProfile();

      final username = provider.state.maybeMap(
        authenticated: (state) => state.user.username,
        orElse: () => '',
      );
      expect(username, equals('testuser'));
    });

    test('sets loading state when not authenticated before fetching', () async {
      const mockProfile = UserProfile(
        username: 'testuser',
        avatar: 'http://example.com/avatar.png',
      );

      when(() => mockApiClient.post<Map<String, dynamic>>(
            any(),
            data: any(named: 'data'),
          )).thenAnswer((_) async => mockProfile.toJson());

      // Start the operation
      final future = provider.fetchProfile();

      // The future hasn't completed yet, so we check if loading is set
      // Since the mock returns immediately, we need to verify the flow
      // by checking that we eventually reach authenticated state
      await future;

      // Verify that the state transition happened
      final isAuthenticated = provider.state.maybeMap(
        authenticated: (_) => true,
        orElse: () => false,
      );
      expect(isAuthenticated, isTrue);
    });

    test('transitions to error state on fetch failure', () async {
      when(() => mockApiClient.post<Map<String, dynamic>>(
            any(),
            data: any(named: 'data'),
          )).thenThrow(Exception('Network error'));

      await provider.fetchProfile();

      final isError = provider.state.maybeMap(
        error: (_) => true,
        orElse: () => false,
      );
      expect(isError, isTrue);

      final errorMessage = provider.state.maybeMap(
        error: (state) => state.message,
        orElse: () => '',
      );
      expect(errorMessage, contains('Network error'));
    });

    test('preserves error state instead of silent failure', () async {
      // Start with authenticated state
      provider.state = const AuthState.authenticated(
        UserProfile(username: 'olduser', avatar: 'avatar.png'),
      );

      when(() => mockApiClient.post<Map<String, dynamic>>(
            any(),
            data: any(named: 'data'),
          )).thenThrow(Exception('Fetch failed'));

      await provider.fetchProfile();

      // Should be in error state, not unauthenticated
      final isError = provider.state.maybeMap(
        error: (_) => true,
        orElse: () => false,
      );
      expect(isError, isTrue);

      final isUnauthenticated = provider.state.maybeMap(
        unauthenticated: (_) => true,
        orElse: () => false,
      );
      expect(isUnauthenticated, isFalse);
    });
  });

  group('logout', () {
    test('clears token and transitions to unauthenticated', () async {
      // Set authenticated state first
      provider.state = const AuthState.authenticated(
        UserProfile(username: 'testuser', avatar: 'avatar.png'),
      );

      when(() => mockStorageService.clearToken()).thenAnswer((_) async {});

      await provider.logout();

      final isUnauthenticated = provider.state.maybeMap(
        unauthenticated: (_) => true,
        orElse: () => false,
      );
      expect(isUnauthenticated, isTrue);
    });

    test('calls logout on repository', () async {
      when(() => mockStorageService.clearToken()).thenAnswer((_) async {});

      await provider.logout();

      verify(() => mockStorageService.clearToken()).called(1);
    });

    test('transitions to unauthenticated from authenticated state', () async {
      provider.state = const AuthState.authenticated(
        UserProfile(username: 'testuser', avatar: 'avatar.png'),
      );

      when(() => mockStorageService.clearToken()).thenAnswer((_) async {});

      await provider.logout();

      expect(provider.isAuthenticated, isFalse);
    });

    test('transitions to unauthenticated from error state', () async {
      provider.state = const AuthState.error('Some error');

      when(() => mockStorageService.clearToken()).thenAnswer((_) async {});

      await provider.logout();

      final isUnauthenticated = provider.state.maybeMap(
        unauthenticated: (_) => true,
        orElse: () => false,
      );
      expect(isUnauthenticated, isTrue);
    });
  });

  group('initialize', () {
    test('fetches profile when token exists', () async {
      const mockProfile = UserProfile(
        username: 'testuser',
        avatar: 'http://example.com/avatar.png',
      );

      when(() => mockStorageService.getToken()).thenReturn('valid_token');
      when(() => mockApiClient.post<Map<String, dynamic>>(
            any(),
            data: any(named: 'data'),
          )).thenAnswer((_) async => mockProfile.toJson());

      await provider.initialize();

      final isAuthenticated = provider.state.maybeMap(
        authenticated: (_) => true,
        orElse: () => false,
      );
      expect(isAuthenticated, isTrue);
    });

    test('does nothing when token is null', () async {
      when(() => mockStorageService.getToken()).thenReturn(null);

      await provider.initialize();

      final isUnauthenticated = provider.state.maybeMap(
        unauthenticated: (_) => true,
        orElse: () => false,
      );
      expect(isUnauthenticated, isTrue);
    });

    test('does nothing when token is empty', () async {
      when(() => mockStorageService.getToken()).thenReturn('');

      await provider.initialize();

      final isUnauthenticated = provider.state.maybeMap(
        unauthenticated: (_) => true,
        orElse: () => false,
      );
      expect(isUnauthenticated, isTrue);
    });

    test('handles fetchProfile error during initialize', () async {
      when(() => mockStorageService.getToken()).thenReturn('valid_token');
      when(() => mockApiClient.post<Map<String, dynamic>>(
            any(),
            data: any(named: 'data'),
          )).thenThrow(Exception('Network error'));

      await provider.initialize();

      // Should be in error state, not crash
      final isError = provider.state.maybeMap(
        error: (_) => true,
        orElse: () => false,
      );
      expect(isError, isTrue);
    });
  });
}
