import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter_practice/features/auth/data/models/user_profile.dart';

part 'auth_state.freezed.dart';

/// Represents the authentication state of the application.
///
/// This model uses freezed for immutability and code generation
/// following the clean architecture pattern.
///
/// ## State Flow
/// The authentication state transitions as follows:
///
/// 1. **Initial State**: `AuthState.unauthenticated()` - User is not logged in
/// 2. **Loading State**: `AuthState.loading()` - Login/logout in progress
/// 3. **Success State**: `AuthState.authenticated(user)` - User is logged in
/// 4. **Error State**: `AuthState.error(message)` - Authentication failed
///
/// The state typically flows from `unauthenticated` → `loading` →
/// `authenticated` or `error` during login, and from `authenticated` →
/// `loading` → `unauthenticated` during logout.
@freezed
class AuthState with _$AuthState {
  const AuthState._();

  /// Represents the state when no user is currently authenticated.
  ///
  /// This is the initial state of the application and the state
  /// after a successful logout.
  const factory AuthState.unauthenticated() = _Unauthenticated;

  /// Represents the state when a user is successfully authenticated.
  ///
  /// Contains the [user] profile information retrieved from the
  /// authentication server.
  const factory AuthState.authenticated(UserProfile user) = _Authenticated;

  /// Represents the state during an authentication operation.
  ///
  /// This state is active while login, logout, or token refresh
  /// operations are in progress.
  const factory AuthState.loading() = _Loading;

  /// Represents an authentication error state.
  ///
  /// Contains a [message] describing the error that occurred during
  /// authentication, such as invalid credentials or network failure.
  const factory AuthState.error(String message) = _Error;
}
