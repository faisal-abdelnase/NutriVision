import '../../domain/entities/onboarding_state.dart';
import '../../domain/repositories/onboarding_repository.dart';
import '../datasources/onboarding_local_data_source.dart';
import '../models/onboarding_state_model.dart';

class OnboardingRepositoryImpl implements OnboardingRepository {
  final OnboardingLocalDataSource localDataSource;

  OnboardingRepositoryImpl({required this.localDataSource});

  @override
  Future<OnboardingState> getOnboardingState() async {
    return localDataSource.readOnboardingState();
  }

  @override
  Future<void> completeOnboarding() async {
    final state = OnboardingStateModel(
      isCompleted: true,
      completedAt: DateTime.now(),
    );

    await localDataSource.saveOnboardingState(state);
  }
}
