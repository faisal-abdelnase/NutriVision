import '../entities/onboarding_state.dart';

abstract class OnboardingRepository {
  Future<OnboardingState> getOnboardingState();

  Future< void> completeOnboarding();
}