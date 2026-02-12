import 'package:shared_preferences/shared_preferences.dart';

/// Service for managing authentication token persistence.
///
/// Provides methods to save, retrieve, and clear authentication tokens
/// using SharedPreferences for local storage.
class AuthStorageService {
  /// SharedPreferences instance for storing data.
  final SharedPreferences _prefs;

  /// Key used for storing the authentication token.
  static const String _tokenKey = 'auth_token';

  /// Creates a new [AuthStorageService] instance.
  ///
  /// Requires a [SharedPreferences] instance for storage operations.
  const AuthStorageService(this._prefs);

  /// Saves the authentication token to local storage.
  ///
  /// Stores the provided [token] using the 'auth_token' key.
  /// Returns `Future<void>` that completes when the token is saved.
  ///
  /// Example:
  /// ```dart
  /// await storageService.saveToken('your_jwt_token_here');
  /// ```
  Future<void> saveToken(String token) async {
    await _prefs.setString(_tokenKey, token);
  }

  /// Retrieves the stored authentication token.
  ///
  /// Returns the token string if it exists, otherwise returns `null`.
  ///
  /// Example:
  /// ```dart
  /// final token = storageService.getToken();
  /// if (token != null) {
  ///   // Use token for authenticated requests
  /// }
  /// ```
  String? getToken() {
    return _prefs.getString(_tokenKey);
  }

  /// Clears the stored authentication token.
  ///
  /// Removes the token from local storage. This is typically called
  /// during logout operations.
  ///
  /// Example:
  /// ```dart
  /// await storageService.clearToken();
  /// ```
  Future<void> clearToken() async {
    await _prefs.remove(_tokenKey);
  }
}
