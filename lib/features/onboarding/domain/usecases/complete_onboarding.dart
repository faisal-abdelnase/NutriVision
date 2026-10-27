import '../repositories/onboarding_repository.dart';

class CompleteOnboarding {
  final OnboardingRepository repository;

  const CompleteOnboarding(this.repository);

  Future<void> call() {
    return repository.completeOnboarding();
  }
}
