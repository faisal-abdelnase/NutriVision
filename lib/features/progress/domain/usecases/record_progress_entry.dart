
import '../entities/progress_entry.dart';
import '../repositories/progress_repository.dart';

class RecordProgressEntry {
  final ProgressRepository repository;

  RecordProgressEntry(this.repository);

  Future<ProgressEntry> call({
    required ProgressEntry entry,
  }) {
    return repository.recordProgressEntry(entry: entry);
  }
}
