import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/nutrition_profile/data/datasources/nutrition_profile_local_data_source.dart';
import '../../features/nutrition_profile/data/datasources/nutrition_profile_remote_data_source.dart';
import '../../features/nutrition_profile/data/datasources/nutrition_profile_remote_data_source_impl.dart';
import '../../features/nutrition_profile/data/repositories/nutrition_profile_repository_impl.dart';

import '../../features/nutrition_profile/domain/repositories/nutrition_profile_repository.dart';
import '../../features/nutrition_profile/domain/usecases/create_nutrition_profile.dart';
import '../../features/nutrition_profile/domain/usecases/get_nutrition_profile.dart';
import '../../features/nutrition_profile/domain/usecases/update_dietary_preferences.dart';
import '../../features/nutrition_profile/domain/usecases/update_nutrition_goals.dart';
import '../../features/nutrition_profile/domain/usecases/update_nutrition_profile.dart';

import '../../features/nutrition_profile/presentation/cubit/nutrition_profile_cubit.dart';

final sl = GetIt.instance;

Future<void> setupServiceLocator() async {
  // Firebase
  if (!sl.isRegistered<FirebaseFirestore>()) {
    sl.registerLazySingleton<FirebaseFirestore>(
      () => FirebaseFirestore.instance,
    );
  }

  // Data Sources
  if (sl.isRegistered<SharedPreferences>()) {
    sl.registerLazySingleton<NutritionProfileLocalDataSource>(
      () => NutritionProfileLocalDataSourceImpl(
        preferences: sl<SharedPreferences>(),
      ),
    );
  }

  sl.registerLazySingleton<NutritionProfileRemoteDataSource>(
    () => NutritionProfileRemoteDataSourceImpl(
      firestore: sl<FirebaseFirestore>(),
    ),
  );

  // Repository
  sl.registerLazySingleton<NutritionProfileRepository>(
    () => NutritionProfileRepositoryImpl(
      remoteDataSource: sl<NutritionProfileRemoteDataSource>(),
      localDataSource: sl.isRegistered<NutritionProfileLocalDataSource>()
          ? sl<NutritionProfileLocalDataSource>()
          : null,
    ),
  );

  // Use Cases
  sl.registerLazySingleton(
    () => GetNutritionProfile(sl<NutritionProfileRepository>()),
  );

  sl.registerLazySingleton(
    () => CreateNutritionProfile(sl<NutritionProfileRepository>()),
  );

  sl.registerLazySingleton(
    () => UpdateNutritionProfile(sl<NutritionProfileRepository>()),
  );

  sl.registerLazySingleton(
    () => UpdateNutritionGoals(sl<NutritionProfileRepository>()),
  );

  sl.registerLazySingleton(
    () => UpdateDietaryPreferences(sl<NutritionProfileRepository>()),
  );

  // Cubit
  sl.registerFactory(
    () => NutritionProfileCubit(
      getNutritionProfile: sl<GetNutritionProfile>(),
      createNutritionProfile: sl<CreateNutritionProfile>(),
      updateNutritionProfile: sl<UpdateNutritionProfile>(),
      updateNutritionGoals: sl<UpdateNutritionGoals>(),
      updateDietaryPreferences: sl<UpdateDietaryPreferences>(),
    ),
  );
}
