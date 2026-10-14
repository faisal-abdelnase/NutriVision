
import '../entities/progress_entry.dart';
import '../repositories/progress_repository.dart';

abstract class RecordProgressEntry {
  final ProgressRepository repository;

  RecordProgressEntry(this.repository);

  Future<ProgressEntry> call({
    required ProgressEntry entry,
  });
}