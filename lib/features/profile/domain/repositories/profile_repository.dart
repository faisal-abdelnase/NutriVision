
import '../entities/user_profile.dart';

abstract class ProfileRepository {
  Future<UserProfile?> getUserProfile({
    required String userId,
  });

  Future<UserProfile> updateUserProfile({
    required UserProfile profile,
  });

  Future<String> uploadProfilePhoto({
    required String userId,
    required String imagePath,
  });

  Future<void> deleteProfilePhoto({
    required String userId,
  });

  Future<void> deleteUserAccount({
    required String userId,
    required String reauthenticationToken,
  });
}