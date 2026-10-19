import '../entities/onboarding_state.dart';
import '../repositories/onboarding_repository.dart';

class HasCompletedOnboarding {
  final OnboardingRepository repository;

  const HasCompletedOnboarding(this.repository);

  Future<OnboardingState> call() {
    return repository.getOnboardingState();
  }
}