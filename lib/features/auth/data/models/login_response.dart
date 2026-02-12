import 'package:freezed_annotation/freezed_annotation.dart';

part 'login_response.freezed.dart';
part 'login_response.g.dart';

/// Represents a login response containing authentication tokens.
///
/// This model uses freezed for immutability, code generation,
/// and JSON serialization following the clean architecture pattern.
///
/// The response includes tokens for authentication and token refresh,
/// along with metadata about token expiration.
@freezed
class LoginResponse with _$LoginResponse {
  const LoginResponse._();

  const factory LoginResponse({
    /// The type of token (typically "Bearer").
    ///
    /// This value is used in the Authorization header when making
    /// authenticated API requests.
    required String tokenType,

    /// The access token used for authenticating API requests.
    ///
    /// This token should be included in the Authorization header
    /// as "Bearer: {accessToken}".
    required String accessToken,

    /// The refresh token used to obtain a new access token.
    ///
    /// When the access token expires, use this token to request
    /// a new access token without requiring the user to log in again.
    required String refreshToken,

    /// The time period in seconds until the access token expires.
    ///
    /// After this duration elapses, the access token will no longer
    /// be valid for authentication and must be refreshed.
    required int expiresIn,
  }) = _LoginResponse;

  /// Creates a LoginResponse from JSON data.
  factory LoginResponse.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseFromJson(json);
}
