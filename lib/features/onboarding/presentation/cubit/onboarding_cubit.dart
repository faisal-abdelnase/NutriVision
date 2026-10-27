import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/complete_onboarding.dart';
import '../../domain/usecases/has_completed_onboarding.dart';

import 'onboarding_state.dart';

class OnboardingCubit extends Cubit<OnboardingCubitState> {
  final HasCompletedOnboarding hasCompletedOnboarding;
  final CompleteOnboarding completeOnboarding;

  OnboardingCubit({
    required this.hasCompletedOnboarding,
    required this.completeOnboarding,
  }) : super(const OnboardingCubitState());

  Future<void> checkOnboardingStatus() async {
    emit(const OnboardingCubitState(status: OnboardingStatus.loading));

    try {
      final onboardingState = await hasCompletedOnboarding();

      emit(
        OnboardingCubitState(
          status: onboardingState.isCompleted
              ? OnboardingStatus.completed
              : OnboardingStatus.notCompleted,
        ),
      );
    } catch (error) {
      emit(
        OnboardingCubitState(
          status: OnboardingStatus.error,
          errorMessage: error.toString(),
        ),
      );
    }
  }

  Future<void> complete() async {
    emit(const OnboardingCubitState(status: OnboardingStatus.loading));

    try {
      await completeOnboarding();

      emit(const OnboardingCubitState(status: OnboardingStatus.completed));
    } catch (error) {
      emit(
        OnboardingCubitState(
          status: OnboardingStatus.error,
          errorMessage: error.toString(),
        ),
      );
    }
  }
}
