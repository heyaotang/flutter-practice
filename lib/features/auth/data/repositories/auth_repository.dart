import 'package:flutter_practice/core/network/api_client.dart';
import 'package:flutter_practice/features/auth/data/models/models.dart';
import 'package:flutter_practice/features/auth/data/services/auth_storage_service.dart';

/// Repository for authentication operations.
///
/// This repository handles authentication-related data operations including
/// login, profile fetching, logout, and token storage. It serves as the
/// single source of truth for authentication data in the application.
///
/// The repository follows the clean architecture pattern by abstracting
/// the data layer from the presentation layer.
class AuthRepository {
  /// Creates a new [AuthRepository] instance.
  ///
  /// Requires both [apiClient] for network operations and [storageService]
  /// for local token persistence.
  AuthRepository({
    required this.apiClient,
    required this.storageService,
  });

  /// HTTP client for making API requests.
  final ApiClient apiClient;

  /// Service for persisting authentication tokens locally.
  final AuthStorageService storageService;

  /// Performs user login with the provided credentials.
  ///
  /// Takes a [LoginRequest] containing username and password, sends it
  /// to the authentication endpoint, and returns a [LoginResponse] containing
  /// the access token, refresh token, and token metadata.
  ///
  /// Throws [ApiException] if the login request fails.
  Future<LoginResponse> login(LoginRequest request) async {
    final response = await apiClient.post<Map<String, dynamic>>(
      '/login',
      data: request.toJson(),
    );
    return LoginResponse.fromJson(response);
  }

  /// Fetches the current user's profile from the server.
  ///
  /// Returns a [UserProfile] containing the user's information including
  /// username and avatar URL.
  ///
  /// Throws [ApiException] if the profile request fails.
  Future<UserProfile> getProfile() async {
    final response = await apiClient.post<Map<String, dynamic>>(
      '/profile',
      data: {},
    );
    return UserProfile.fromJson(response);
  }

  /// Logs out the current user by clearing the locally stored token.
  ///
  /// This method only clears the local token. It does not make any
  /// network requests to invalidate the token on the server.
  Future<void> logout() async {
    await storageService.clearToken();
  }

  /// Retrieves the stored authentication token from local storage.
  ///
  /// Returns the access token string if it exists, otherwise returns `null`.
  /// This method is useful for checking if a user is already authenticated
  /// when the app starts.
  Future<String?> getStoredToken() async {
    return storageService.getToken();
  }
}
