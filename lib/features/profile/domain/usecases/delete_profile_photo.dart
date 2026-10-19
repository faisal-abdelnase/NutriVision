import '../repositories/profile_repository.dart';

class DeleteProfilePhoto {
  final ProfileRepository repository;

  DeleteProfilePhoto(this.repository);

  Future<void> call({
    required String userId,
  }) {
    return repository.deleteProfilePhoto(userId: userId);
  }
}