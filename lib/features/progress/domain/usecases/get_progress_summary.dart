

import '../entities/progress_summary.dart';
import '../repositories/progress_repository.dart';

abstract class GetProgressSummary {
  final ProgressRepository repository;

  GetProgressSummary(this.repository);

  Future<ProgressSummary> call({
    required String userId,
    required DateTime startDate,
    required DateTime endDate,
  });
}