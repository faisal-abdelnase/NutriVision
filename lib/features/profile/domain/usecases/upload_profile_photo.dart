

import '../repositories/profile_repository.dart';

abstract class UploadProfilePhoto {
  final ProfileRepository repository;

  UploadProfilePhoto(this.repository);

  Future<String> call({
    required String userId,
    required String imagePath,
  });
}