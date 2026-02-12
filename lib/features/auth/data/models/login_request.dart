import 'package:freezed_annotation/freezed_annotation.dart';

part 'login_request.freezed.dart';
part 'login_request.g.dart';

/// Represents a login request containing user credentials.
///
/// This model uses freezed for immutability, code generation,
/// and JSON serialization following the clean architecture pattern.
///
/// The [username] and [password] fields are required and will be
/// sent to the authentication server for validation.
@freezed
class LoginRequest with _$LoginRequest {
  const LoginRequest._();

  const factory LoginRequest({
    /// The username or email address of the user attempting to log in.
    required String username,

    /// The password for the user attempting to log in.
    required String password,
  }) = _LoginRequest;

  /// Creates a LoginRequest from JSON data.
  factory LoginRequest.fromJson(Map<String, dynamic> json) =>
      _$LoginRequestFromJson(json);
}
