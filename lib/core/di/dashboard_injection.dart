import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';

import '../../features/dashboard/data/datasources/dashboard_remote_data_source.dart';
import '../../features/dashboard/data/datasources/dashboard_remote_data_source_impl.dart';
import '../../features/dashboard/data/repositories/dashboard_repository_impl.dart';
import '../../features/dashboard/domain/repositories/dashboard_repository.dart';
import '../../features/dashboard/domain/usecases/get_daily_nutrition_summary.dart';
import '../../features/dashboard/domain/usecases/get_recent_meals_summary.dart';
import '../../features/dashboard/presentation/cubit/dashboard_cubit.dart';

final GetIt sl = GetIt.instance;

void registerDashboardDependencies() {
  sl.registerLazySingleton<FirebaseFirestore>(() => FirebaseFirestore.instance);

  // Data Source
  sl.registerLazySingleton<DashboardRemoteDataSource>(
    () => DashboardRemoteDataSourceImpl(firestore: sl<FirebaseFirestore>()),
  );

  // Repository
  sl.registerLazySingleton<DashboardRepository>(
    () => DashboardRepositoryImpl(
      remoteDataSource: sl<DashboardRemoteDataSource>(),
    ),
  );

  // Use Cases
  sl.registerLazySingleton<GetDailyNutritionSummary>(
    () => GetDailyNutritionSummary(sl<DashboardRepository>()),
  );

  sl.registerLazySingleton<GetRecentMealsSummary>(
    () => GetRecentMealsSummary(sl<DashboardRepository>()),
  );

  // Cubit
  sl.registerFactory<DashboardCubit>(
    () => DashboardCubit(
      getDailyNutritionSummary: sl<GetDailyNutritionSummary>(),
      getRecentMealsSummary: sl<GetRecentMealsSummary>(),
    ),
  );
}
