import '../repositories/progress_repository.dart';

class DeleteProgressEntry {
  final ProgressRepository repository;

  DeleteProgressEntry(this.repository);

  Future<void> call({required String userId, required String entryId}) {
    return repository.deleteProgressEntry(userId: userId, entryId: entryId);
  }
}
