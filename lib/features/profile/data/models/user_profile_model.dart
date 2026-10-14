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
}

abstract class UserProfileModelMapper {
  UserProfileModel fromJson(
    Map<String, dynamic> json,
  );

  Map<String, dynamic> toJson(
    UserProfileModel model,
  );

  
}