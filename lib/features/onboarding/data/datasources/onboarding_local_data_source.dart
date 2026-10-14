import '../models/onboarding_state_model.dart';

abstract class OnboardingLocalDataSource {
  Future<OnboardingStateModel> readOnboardingState();

  Future<void> saveOnboardingState(
    OnboardingStateModel state,
  );
}