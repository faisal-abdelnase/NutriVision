
import '../entities/progress_entry.dart';
import '../repositories/progress_repository.dart';

class GetProgressHistory {
  final ProgressRepository repository;

  GetProgressHistory(this.repository);

  Future<List<ProgressEntry>> call({
    required String userId,
    required DateTime startDate,
    required DateTime endDate,
    required int page,
    required int pageSize,
  }) {
    return repository.getProgressHistory(
      userId: userId,
      startDate: startDate,
      endDate: endDate,
      page: page,
      pageSize: pageSize,
    );
  }
}
