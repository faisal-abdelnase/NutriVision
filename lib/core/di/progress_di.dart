import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';

import '../../features/progress/data/datasources/progress_remote_data_source.dart';
import '../../features/progress/data/datasources/progress_remote_data_source_impl.dart';
import '../../features/progress/data/repositories/progress_repository_impl.dart';
import '../../features/progress/domain/repositories/progress_repository.dart';
import '../../features/progress/domain/usecases/delete_progress_entry.dart';
import '../../features/progress/domain/usecases/get_nutrition_trends.dart';
import '../../features/progress/domain/usecases/get_progress_history.dart';
import '../../features/progress/domain/usecases/get_progress_summary.dart';
import '../../features/progress/domain/usecases/record_progress_entry.dart';
import '../../features/progress/domain/usecases/update_progress_entry.dart';
import '../../features/progress/presentation/cubit/progress_cubit.dart';


final sl = GetIt.instance;
void registerProgressDependencies() {
  sl.registerLazySingleton<ProgressRemoteDataSource>(
    () => ProgressRemoteDataSourceImpl(
      firestore: sl<FirebaseFirestore>(),
    ),
  );

  sl.registerLazySingleton<ProgressRepository>(
    () => ProgressRepositoryImpl(
      remoteDataSource: sl<ProgressRemoteDataSource>(),
    ),
  );

  sl.registerLazySingleton(
    () => RecordProgressEntry(sl<ProgressRepository>()),
  );

  sl.registerLazySingleton(
    () => UpdateProgressEntry(sl<ProgressRepository>()),
  );

  sl.registerLazySingleton(
    () => DeleteProgressEntry(sl<ProgressRepository>()),
  );

  sl.registerLazySingleton(
    () => GetProgressHistory(sl<ProgressRepository>()),
  );

  sl.registerLazySingleton(
    () => GetProgressSummary(sl<ProgressRepository>()),
  );

  sl.registerLazySingleton(
    () => GetNutritionTrends(sl<ProgressRepository>()),
  );

  sl.registerFactory(
    () => ProgressCubit(
      recordProgressEntry: sl<RecordProgressEntry>(),
      updateProgressEntry: sl<UpdateProgressEntry>(),
      deleteProgressEntry: sl<DeleteProgressEntry>(),
      getProgressHistory: sl<GetProgressHistory>(),
      getProgressSummary: sl<GetProgressSummary>(),
      getNutritionTrends: sl<GetNutritionTrends>(),
    ),
  );
}