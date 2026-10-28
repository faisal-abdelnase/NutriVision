import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:get_it/get_it.dart';

import '../../features/meal_analysis/data/datasources/meal_analysis_local_data_source.dart';
import '../../features/meal_analysis/data/datasources/meal_analysis_local_data_source_impl.dart';
import '../../features/meal_analysis/data/datasources/meal_analysis_remote_data_source.dart';
import '../../features/meal_analysis/data/datasources/meal_analysis_remote_data_source_impl.dart';
import '../../features/meal_analysis/data/repositories/meal_analysis_repository_impl.dart';
import '../../features/meal_analysis/domain/repositories/meal_analysis_repository.dart';
import '../../features/meal_analysis/domain/usecases/analyze_meal_from_image.dart';
import '../../features/meal_analysis/domain/usecases/analyze_meal_from_text.dart';
import '../../features/meal_analysis/domain/usecases/get_meal_analysis_by_id.dart';
import '../../features/meal_analysis/domain/usecases/get_meal_analysis_history.dart';
import '../../features/meal_analysis/domain/usecases/save_meal_analysis.dart';
import '../../features/meal_analysis/presentation/cubit/meal_analysis_cubit.dart';

final getIt = GetIt.instance;

Future<void> initMealAnalysisInjection() async {
  // Data Sources

  getIt.registerLazySingleton<MealAnalysisRemoteDataSource>(
    () => MealAnalysisRemoteDataSourceImpl(
      dio: getIt<Dio>(),
      firestore: getIt<FirebaseFirestore>(),
    ),
  );

  getIt.registerLazySingleton<MealAnalysisLocalDataSource>(
    () => MealAnalysisLocalDataSourceImpl(
      preferences: getIt<SharedPreferences>(),
    ),
  );

  // Repository

  getIt.registerLazySingleton<MealAnalysisRepository>(
    () => MealAnalysisRepositoryImpl(
      remoteDataSource: getIt<MealAnalysisRemoteDataSource>(),
      localDataSource: getIt<MealAnalysisLocalDataSource>(),
    ),
  );

  // Use Cases

  getIt.registerLazySingleton(
    () => AnalyzeMealFromText(getIt<MealAnalysisRepository>()),
  );

  getIt.registerLazySingleton(
    () => AnalyzeMealFromImage(getIt<MealAnalysisRepository>()),
  );

  getIt.registerLazySingleton(
    () => GetMealAnalysisById(getIt<MealAnalysisRepository>()),
  );

  getIt.registerLazySingleton(
    () => GetMealAnalysisHistory(getIt<MealAnalysisRepository>()),
  );

  getIt.registerLazySingleton(
    () => SaveMealAnalysis(getIt<MealAnalysisRepository>()),
  );

  // Cubit

  getIt.registerFactory(
    () => MealAnalysisCubit(
      analyzeMealFromText: getIt<AnalyzeMealFromText>(),
      analyzeMealFromImage: getIt<AnalyzeMealFromImage>(),
      getMealAnalysisById: getIt<GetMealAnalysisById>(),
      getMealAnalysisHistory: getIt<GetMealAnalysisHistory>(),
      saveMealAnalysis: getIt<SaveMealAnalysis>(),
    ),
  );
}
