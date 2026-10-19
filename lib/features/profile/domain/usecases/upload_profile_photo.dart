import '../repositories/profile_repository.dart';

class UploadProfilePhoto {
  final ProfileRepository repository;

  UploadProfilePhoto(this.repository);

  Future<String> call({
    required String userId,
    required String imagePath,
  }) {
    return repository.uploadProfilePhoto(
      userId: userId,
      imagePath: imagePath,
    );
  }
}