
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';

import '../../features/meal_tracking/data/datasources/meal_remote_data_source.dart';
import '../../features/meal_tracking/data/datasources/meal_remote_data_source_impl.dart';
import '../../features/meal_tracking/data/repositories/meal_repository_impl.dart';
import '../../features/meal_tracking/domain/repositories/meal_repository.dart';
import '../../features/meal_tracking/domain/usecases/add_meal.dart';
import '../../features/meal_tracking/domain/usecases/delete_meal.dart';
import '../../features/meal_tracking/domain/usecases/get_meal_by_id.dart';
import '../../features/meal_tracking/domain/usecases/get_meal_history.dart';
import '../../features/meal_tracking/domain/usecases/get_meals_by_date.dart';
import '../../features/meal_tracking/domain/usecases/update_meal.dart';
import '../../features/meal_tracking/presentation/cubit/meal_cubit.dart';

final sl = GetIt.instance;

Future<void> initMealTrackingDependencies() async {
  // External dependency
  if (!sl.isRegistered<FirebaseFirestore>()) {
    sl.registerLazySingleton<FirebaseFirestore>(
      () => FirebaseFirestore.instance,
    );
  }

  // Data source
  sl.registerLazySingleton<MealRemoteDataSource>(
    () => MealRemoteDataSourceImpl(
      firestore: sl<FirebaseFirestore>(),
    ),
  );

  // Repository
  sl.registerLazySingleton<MealRepository>(
    () => MealRepositoryImpl(
      remoteDataSource: sl<MealRemoteDataSource>(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(
    () => AddMeal(sl<MealRepository>()),
  );

  sl.registerLazySingleton(
    () => UpdateMeal(sl<MealRepository>()),
  );

  sl.registerLazySingleton(
    () => DeleteMeal(sl<MealRepository>()),
  );

  sl.registerLazySingleton(
    () => GetMealById(sl<MealRepository>()),
  );

  sl.registerLazySingleton(
    () => GetMealHistory(sl<MealRepository>()),
  );

  sl.registerLazySingleton(
    () => GetMealsByDate(sl<MealRepository>()),
  );

  // Cubit
  sl.registerFactory(
    () => MealCubit(
      addMealUseCase: sl<AddMeal>(),
      updateMealUseCase: sl<UpdateMeal>(),
      deleteMealUseCase: sl<DeleteMeal>(),
      getMealByIdUseCase: sl<GetMealById>(),
      getMealHistoryUseCase: sl<GetMealHistory>(),
      getMealsByDateUseCase: sl<GetMealsByDate>(),
    ),
  );
}
