import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/onboarding/data/datasources/onboarding_local_data_source.dart';
import '../../features/onboarding/data/repositories/onboarding_repository_impl.dart';
import '../../features/onboarding/domain/repositories/onboarding_repository.dart';
import '../../features/onboarding/domain/usecases/complete_onboarding.dart';
import '../../features/onboarding/domain/usecases/has_completed_onboarding.dart';
import '../../features/onboarding/presentation/cubit/onboarding_cubit.dart';

final GetIt sl = GetIt.instance;

Future<void> registerOnboardingDependencies() async {
  final sharedPreferences = await SharedPreferences.getInstance();

  sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);

  sl.registerLazySingleton<OnboardingLocalDataSource>(
    () => OnboardingLocalDataSourceImpl(
      sharedPreferences: sl<SharedPreferences>(),
    ),
  );

  sl.registerLazySingleton<OnboardingRepository>(
    () => OnboardingRepositoryImpl(
      localDataSource: sl<OnboardingLocalDataSource>(),
    ),
  );

  sl.registerLazySingleton<CompleteOnboarding>(
    () => CompleteOnboarding(sl<OnboardingRepository>()),
  );

  sl.registerLazySingleton<HasCompletedOnboarding>(
    () => HasCompletedOnboarding(sl<OnboardingRepository>()),
  );

  sl.registerFactory<OnboardingCubit>(
    () => OnboardingCubit(
      hasCompletedOnboarding: sl<HasCompletedOnboarding>(),
      completeOnboarding: sl<CompleteOnboarding>(),
    ),
  );
}
