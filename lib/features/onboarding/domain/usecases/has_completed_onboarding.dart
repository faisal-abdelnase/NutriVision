
import '../entities/onboarding_state.dart';
import '../repositories/onboarding_repository.dart';

abstract class HasCompletedOnboarding {
  final OnboardingRepository repository;

  HasCompletedOnboarding(this.repository);

  Future<OnboardingState> call();
}