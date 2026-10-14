abstract class ProfileStorageDataSource {
  Future<String> uploadProfileImage({
    required String userId,
    required String imagePath,
  });

  Future<void> deleteProfileImage({
    required String userId,
    required String imageUrl,
  });

  Future<bool> profileImageExists({
    required String userId,
    required String imageUrl,
  });
}