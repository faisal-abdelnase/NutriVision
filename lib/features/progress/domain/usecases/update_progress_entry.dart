import '../entities/progress_entry.dart';
import '../repositories/progress_repository.dart';

class UpdateProgressEntry {
  final ProgressRepository repository;

  UpdateProgressEntry(this.repository);

  Future<ProgressEntry> call({required ProgressEntry entry}) {
    return repository.updateProgressEntry(entry: entry);
  }
}
