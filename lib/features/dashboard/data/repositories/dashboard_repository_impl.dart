

import '../../domain/entities/daily_nutrition_summary.dart';
import '../../domain/entities/recent_meal_summary.dart';
import '../../domain/repositories/dashboard_repository.dart';
import '../datasources/dashboard_remote_data_source.dart';

abstract class DashboardRepositoryImpl
    implements DashboardRepository {
  final DashboardRemoteDataSource remoteDataSource;

  DashboardRepositoryImpl({
    required this.remoteDataSource,
  });

  @override
  Future<DailyNutritionSummary>
      getDailyNutritionSummary({
    required String userId,
    required DateTime date,
  });

  @override
  Future<List<RecentMealSummary>>
      getRecentMealsSummary({
    required String userId,
    required int limit,
  });
}