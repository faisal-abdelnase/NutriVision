import '../entities/progress_summary.dart';
import '../repositories/progress_repository.dart';

class GetProgressSummary {
  final ProgressRepository repository;

  GetProgressSummary(this.repository);

  Future<ProgressSummary> call({
    required String userId,
    required DateTime startDate,
    required DateTime endDate,
  }) {
    return repository.getProgressSummary(
      userId: userId,
      startDate: startDate,
      endDate: endDate,
    );
  }
}
