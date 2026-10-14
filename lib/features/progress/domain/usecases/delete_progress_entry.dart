

import '../repositories/progress_repository.dart';

abstract class DeleteProgressEntry {
  final ProgressRepository repository;

  DeleteProgressEntry(this.repository);

  Future<void> call({
    required String userId,
    required String entryId,
  });
}