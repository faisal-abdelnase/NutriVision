class UserProfile {
  final String userId;

  final String fullName;
  final String email;
  final String? phoneNumber;

  final String? profilePhotoUrl;
  final String? bio;

  final DateTime? dateOfBirth;
  final String? gender;

  final String preferredLanguage;
  final String preferredTheme;

  final bool notificationsEnabled;

  final DateTime createdAt;
  final DateTime? updatedAt;

  const UserProfile({
    required this.userId,
    required this.fullName,
    required this.email,
    this.phoneNumber,
    this.profilePhotoUrl,
    this.bio,
    this.dateOfBirth,
    this.gender,
    required this.preferredLanguage,
    required this.preferredTheme,
    required this.notificationsEnabled,
    required this.createdAt,
    this.updatedAt,
  });
}
