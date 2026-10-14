
import '../repositories/onboarding_repository.dart';

abstract class CompleteOnboarding {
  final OnboardingRepository repository;

  CompleteOnboarding(this.repository);

  Future<void> call();
}