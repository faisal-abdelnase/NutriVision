

import '../entities/progress_entry.dart';
import '../repositories/progress_repository.dart';

abstract class UpdateProgressEntry {
  final ProgressRepository repository;

  UpdateProgressEntry(this.repository);

  Future<ProgressEntry> call({
    required ProgressEntry entry,
  });
}