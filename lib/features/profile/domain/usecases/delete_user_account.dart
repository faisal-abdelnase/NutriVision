import '../repositories/profile_repository.dart';

class DeleteUserAccount {
  final ProfileRepository repository;

  DeleteUserAccount(this.repository);

  Future<void> call({
    required String userId,
    required String reauthenticationToken,
  }) {
    return repository.deleteUserAccount(
      userId: userId,
      reauthenticationToken: reauthenticationToken,
    );
  }
}
