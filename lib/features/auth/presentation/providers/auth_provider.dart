import 'package:flutter/foundation.dart';
import 'package:flutter_practice/core/constants/app_constants.dart';
import 'package:flutter_practice/features/auth/data/models/models.dart';
import 'package:flutter_practice/features/auth/data/repositories/auth_repository.dart';

/// Provider for global authentication state.
///
/// This provider manages the authentication state of the application,
/// including login, logout, profile fetching, and initialization.
/// It extends [ChangeNotifier] to notify listeners of state changes.
///
/// The provider follows the state management pattern where UI components
/// listen to state changes and rebuild accordingly.
class AuthProvider with ChangeNotifier {
  /// Creates a new [AuthProvider] instance.
  ///
  /// Requires [repository] for authentication operations.
  AuthProvider({required this.repository});

  /// Repository for authentication data operations.
  final AuthRepository repository;

  /// Internal state representing the current authentication status.
  AuthState _state = const AuthState.unauthenticated();

  /// Current authentication state.
  ///
  /// This state determines whether the user is logged in, loading,
  /// authenticated, or in an error state.
  AuthState get state => _state;

  /// Indicates whether a user is currently authenticated.
  ///
  /// Returns `true` if the current state is authenticated,
  /// `false` otherwise.
  bool get isAuthenticated => _state.maybeMap(
        authenticated: (_) => true,
        orElse: () => false,
      );

  /// Sets the authentication state directly.
  ///
  /// This is primarily used for testing purposes. The state is
  /// publicly settable for test setup convenience.
  set state(AuthState value) {
    _setState(value);
  }

  /// Logs in the user with the provided credentials.
  ///
  /// Takes [username] and [password], sends them to the authentication
  /// server, and updates the state accordingly.
  ///
  /// On success, saves the access token, fetches the complete user profile,
  /// and transitions to authenticated state. If profile fetch fails, falls back
  /// to using the username with a default avatar.
  ///
  /// Throws [ArgumentError] if username or password is empty.
  /// Throws [Exception] if login fails.
  Future<void> login(String username, String password) async {
    if (username.trim().isEmpty) {
      throw ArgumentError('Username cannot be empty');
    }
    if (password.trim().isEmpty) {
      throw ArgumentError('Password cannot be empty');
    }

    _setState(const AuthState.loading());

    try {
      final request = LoginRequest(username: username, password: password);
      final response = await repository.login(request);

      await repository.storageService.saveToken(response.accessToken);

      try {
        final profile = await repository.getProfile();
        _setState(AuthState.authenticated(profile));
      } catch (profileError) {
        _setState(AuthState.authenticated(
          UserProfile(
            username: username,
            avatar: AppConstants.defaultAvatarUrl,
          ),
        ));
      }
    } catch (e) {
      _setState(AuthState.error(e.toString()));
      rethrow;
    }
  }

  /// Fetches the user profile from the server.
  ///
  /// Retrieves the current user's profile and updates the authenticated
  /// state with the fresh profile data.
  ///
  /// If not currently authenticated, sets loading state before fetching.
  /// On failure, transitions to error state to preserve error information
  /// for UI display.
  Future<void> fetchProfile() async {
    final isAuthenticated = _state.maybeMap(
      authenticated: (_) => true,
      orElse: () => false,
    );

    if (!isAuthenticated) {
      _setState(const AuthState.loading());
    }

    try {
      final profile = await repository.getProfile();
      _setState(AuthState.authenticated(profile));
    } catch (e) {
      _setState(AuthState.error(e.toString()));
    }
  }

  /// Logs out the current user and clears local data.
  ///
  /// Clears the stored authentication token and transitions to
  /// unauthenticated state.
  Future<void> logout() async {
    await repository.logout();
    _setState(const AuthState.unauthenticated());
  }

  /// Initializes the provider by checking for stored token.
  ///
  /// If a valid token is found in storage, attempts to fetch the
  /// user profile to restore the authenticated state.
  ///
  /// This should be called when the app starts to restore any
  /// existing authentication session.
  Future<void> initialize() async {
    final token = await repository.getStoredToken();
    if (token != null && token.isNotEmpty) {
      await fetchProfile();
    }
  }

  /// Updates the internal state and notifies listeners.
  ///
  /// This private method is called internally whenever the authentication
  /// state changes. It ensures all listeners are notified of the change.
  void _setState(AuthState newState) {
    _state = newState;
    notifyListeners();
  }
}
