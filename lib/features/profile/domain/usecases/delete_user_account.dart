

import '../repositories/profile_repository.dart';

abstract class DeleteUserAccount {
  final ProfileRepository repository;

  DeleteUserAccount(this.repository);

  Future<void> call({
    required String userId,
    required String reauthenticationToken,
  });
}