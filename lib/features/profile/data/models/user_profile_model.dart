import '../../domain/entities/user_profile.dart';

class UserProfileModel extends UserProfile {
  const UserProfileModel({
    required super.userId,
    required super.fullName,
    required super.email,
    super.phoneNumber,
    super.profilePhotoUrl,
    super.bio,
    super.dateOfBirth,
    super.gender,
    required super.preferredLanguage,
    required super.preferredTheme,
    required super.notificationsEnabled,
    required super.createdAt,
    super.updatedAt,
  });

  factory UserProfileModel.fromJson(
    Map<String, dynamic> json,
  ) {
    DateTime? parseDate(dynamic value) {
      if (value == null) return null;
      if (value is DateTime) return value;
      if (value is String) return DateTime.tryParse(value);
      return null;
    }

    return UserProfileModel(
      userId: json['userId'] as String,
      fullName: json['fullName'] as String? ?? '',
      email: json['email'] as String? ?? '',
      phoneNumber: json['phoneNumber'] as String?,
      profilePhotoUrl: json['profilePhotoUrl'] as String?,
      bio: json['bio'] as String?,
      dateOfBirth: parseDate(json['dateOfBirth']),
      gender: json['gender'] as String?,
      preferredLanguage:
          json['preferredLanguage'] as String? ?? 'ar',
      preferredTheme:
          json['preferredTheme'] as String? ?? 'system',
      notificationsEnabled:
          json['notificationsEnabled'] as bool? ?? true,
      createdAt: parseDate(json['createdAt']) ??
          DateTime.now(),
      updatedAt: parseDate(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'fullName': fullName,
      'email': email,
      'phoneNumber': phoneNumber,
      'profilePhotoUrl': profilePhotoUrl,
      'bio': bio,
      'dateOfBirth': dateOfBirth?.toIso8601String(),
      'gender': gender,
      'preferredLanguage': preferredLanguage,
      'preferredTheme': preferredTheme,
      'notificationsEnabled': notificationsEnabled,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  factory UserProfileModel.fromEntity(UserProfile profile) {
    return UserProfileModel(
      userId: profile.userId,
      fullName: profile.fullName,
      email: profile.email,
      phoneNumber: profile.phoneNumber,
      profilePhotoUrl: profile.profilePhotoUrl,
      bio: profile.bio,
      dateOfBirth: profile.dateOfBirth,
      gender: profile.gender,
      preferredLanguage: profile.preferredLanguage,
      preferredTheme: profile.preferredTheme,
      notificationsEnabled: profile.notificationsEnabled,
      createdAt: profile.createdAt,
      updatedAt: profile.updatedAt,
    );
  }


  UserProfileModel copyWithPhoto(String? photoUrl) {
  return UserProfileModel(
    userId: userId,
    fullName: fullName,
    email: email,
    phoneNumber: phoneNumber,
    profilePhotoUrl: photoUrl,
    bio: bio,
    dateOfBirth: dateOfBirth,
    gender: gender,
    preferredLanguage: preferredLanguage,
    preferredTheme: preferredTheme,
    notificationsEnabled: notificationsEnabled,
    createdAt: createdAt,
    updatedAt: DateTime.now(),
  );
}
}