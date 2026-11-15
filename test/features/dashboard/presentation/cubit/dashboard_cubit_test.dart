import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nutri_vision/features/dashboard/domain/entities/daily_nutrition_summary.dart';
import 'package:nutri_vision/features/dashboard/domain/entities/recent_meal_summary.dart';
import 'package:nutri_vision/features/dashboard/domain/repositories/dashboard_repository.dart';
import 'package:nutri_vision/features/dashboard/domain/usecases/get_daily_nutrition_summary.dart';
import 'package:nutri_vision/features/dashboard/domain/usecases/get_recent_meals_summary.dart';
import 'package:nutri_vision/features/dashboard/presentation/cubit/dashboard_cubit.dart';
import 'package:nutri_vision/features/dashboard/presentation/cubit/dashboard_state.dart';

class _FailingDashboardRepository implements DashboardRepository {
  _FailingDashboardRepository(this.error);

  final Object error;

  @override
  Future<DailyNutritionSummary> getDailyNutritionSummary({
    required String userId,
    required DateTime date,
  }) {
    return Future.error(error);
  }

  @override
  Future<List<RecentMealSummary>> getRecentMealsSummary({
    required String userId,
    required DateTime date,
    required int limit,
  }) {
    return Future.error(error);
  }
}

void main() {
  test(
    'shows Firestore error code and message when dashboard loading fails',
    () async {
      final repository = _FailingDashboardRepository(
        FirebaseException(
          plugin: 'cloud_firestore',
          code: 'permission-denied',
          message: 'Missing or insufficient permissions.',
        ),
      );
      final cubit = DashboardCubit(
        getDailyNutritionSummary: GetDailyNutritionSummary(repository),
        getRecentMealsSummary: GetRecentMealsSummary(repository),
      );

      await cubit.loadDashboard(userId: 'user-123');

      expect(cubit.state, isA<DashboardError>());
      expect(
        (cubit.state as DashboardError).message,
        contains('permission-denied'),
      );
      expect(
        (cubit.state as DashboardError).message,
        contains('Missing or insufficient permissions.'),
      );

      await cubit.close();
    },
  );
}
