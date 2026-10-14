import '../models/user_profile_model.dart';

abstract class ProfileRemoteDataSource {
  Future<UserProfileModel?> fetchUserProfile({
    required String userId,
  });

  Future<UserProfileModel> updateUserProfile({
    required UserProfileModel profile,
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