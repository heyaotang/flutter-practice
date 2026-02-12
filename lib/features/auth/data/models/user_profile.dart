import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_profile.freezed.dart';
part 'user_profile.g.dart';

/// Represents a user's profile information.
///
/// This model uses freezed for immutability, code generation,
/// and JSON serialization following the clean architecture pattern.
///
/// Contains basic user profile data including username and avatar,
/// typically retrieved from the authentication server after login.
@freezed
class UserProfile with _$UserProfile {
  const UserProfile._();

  const factory UserProfile({
    /// The unique username or display name for the user.
    required String username,

    /// The URL of the user's avatar image.
    ///
    /// This URL can be used to display the user's profile picture
    /// in the UI. The format is typically HTTP/HTTPS URL pointing
    /// to an image resource (e.g., JPG, PNG).
    required String avatar,
  }) = _UserProfile;

  /// Creates a UserProfile from JSON data.
  factory UserProfile.fromJson(Map<String, dynamic> json) =>
      _$UserProfileFromJson(json);
}
