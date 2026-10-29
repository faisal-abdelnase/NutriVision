
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/complete_onboarding.dart';
import '../../domain/usecases/has_completed_onboarding.dart';
import 'onboarding_state.dart';

class OnboardingCubit extends Cubit<OnboardingCubitState> {
  final HasCompletedOnboarding hasCompletedOnboarding;
  final CompleteOnboarding completeOnboarding;

  bool _isChecking = false;
  bool _isCompleting = false;

  OnboardingCubit({
    required this.hasCompletedOnboarding,
    required this.completeOnboarding,
  }) : super(const OnboardingCubitState());

  Future<void> checkOnboardingStatus() async {
    if (_isChecking || _isCompleting || isClosed) return;

    _isChecking = true;

    emit(
      const OnboardingCubitState(
        status: OnboardingStatus.loading,
      ),
    );

    try {
      final onboardingState = await hasCompletedOnboarding();

      if (isClosed) return;

      emit(
        OnboardingCubitState(
          status: onboardingState.isCompleted
              ? OnboardingStatus.completed
              : OnboardingStatus.notCompleted,
        ),
      );
    } catch (error) {
      if (isClosed) return;

      emit(
        OnboardingCubitState(
          status: OnboardingStatus.error,
          errorMessage: error.toString(),
        ),
      );
    } finally {
      _isChecking = false;
    }
  }

  Future<void> complete() async {
    if (_isCompleting || _isChecking || isClosed) return;

    _isCompleting = true;

    emit(
      const OnboardingCubitState(
        status: OnboardingStatus.loading,
      ),
    );

    try {
      await completeOnboarding();

      if (isClosed) return;

      emit(
        const OnboardingCubitState(
          status: OnboardingStatus.completed,
        ),
      );
    } catch (error) {
      if (isClosed) return;

      emit(
        OnboardingCubitState(
          status: OnboardingStatus.error,
          errorMessage: error.toString(),
        ),
      );
    } finally {
      _isCompleting = false;
    }
  }
}
