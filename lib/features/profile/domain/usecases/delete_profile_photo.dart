

import '../repositories/profile_repository.dart';

abstract class DeleteProfilePhoto {
  final ProfileRepository repository;

  DeleteProfilePhoto(this.repository);

  Future<void> call({
    required String userId,
  });
}