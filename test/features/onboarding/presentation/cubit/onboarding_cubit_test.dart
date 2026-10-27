import 'package:flutter_test/flutter_test.dart';
import 'package:nutri_vision/features/onboarding/domain/entities/onboarding_state.dart';
import 'package:nutri_vision/features/onboarding/domain/repositories/onboarding_repository.dart';
import 'package:nutri_vision/features/onboarding/domain/usecases/complete_onboarding.dart';
import 'package:nutri_vision/features/onboarding/domain/usecases/has_completed_onboarding.dart';
import 'package:nutri_vision/features/onboarding/presentation/cubit/onboarding_cubit.dart';
import 'package:nutri_vision/features/onboarding/presentation/cubit/onboarding_state.dart';

class FakeOnboardingRepository implements OnboardingRepository {
  bool isCompleted;
  bool shouldThrow;

  FakeOnboardingRepository({
    this.isCompleted = false,
    this.shouldThrow = false,
  });

  @override
  Future<OnboardingState> getOnboardingState() async {
    if (shouldThrow) throw Exception('Storage error');
    return OnboardingState(isCompleted: isCompleted);
  }

  @override
  Future<void> completeOnboarding() async {
    if (shouldThrow) throw Exception('Save error');
    isCompleted = true;
  }
}

void main() {
  group('OnboardingCubit', () {
    test('initial state has status initial', () {
      final repo = FakeOnboardingRepository();
      final cubit = OnboardingCubit(
        hasCompletedOnboarding: HasCompletedOnboarding(repo),
        completeOnboarding: CompleteOnboarding(repo),
      );

      expect(cubit.state.status, equals(OnboardingStatus.initial));
      cubit.close();
    });

    test(
      'checkOnboardingStatus emits notCompleted when not completed',
      () async {
        final repo = FakeOnboardingRepository(isCompleted: false);
        final cubit = OnboardingCubit(
          hasCompletedOnboarding: HasCompletedOnboarding(repo),
          completeOnboarding: CompleteOnboarding(repo),
        );

        final expectedStates = [
          const OnboardingCubitState(status: OnboardingStatus.loading),
          const OnboardingCubitState(status: OnboardingStatus.notCompleted),
        ];

        final future = expectLater(cubit.stream, emitsInOrder(expectedStates));
        await cubit.checkOnboardingStatus();
        await future;
        cubit.close();
      },
    );

    test(
      'checkOnboardingStatus emits completed when already completed',
      () async {
        final repo = FakeOnboardingRepository(isCompleted: true);
        final cubit = OnboardingCubit(
          hasCompletedOnboarding: HasCompletedOnboarding(repo),
          completeOnboarding: CompleteOnboarding(repo),
        );

        final expectedStates = [
          const OnboardingCubitState(status: OnboardingStatus.loading),
          const OnboardingCubitState(status: OnboardingStatus.completed),
        ];

        final future = expectLater(cubit.stream, emitsInOrder(expectedStates));
        await cubit.checkOnboardingStatus();
        await future;
        cubit.close();
      },
    );

    test(
      'complete() marks onboarding as completed and emits completed status',
      () async {
        final repo = FakeOnboardingRepository(isCompleted: false);
        final cubit = OnboardingCubit(
          hasCompletedOnboarding: HasCompletedOnboarding(repo),
          completeOnboarding: CompleteOnboarding(repo),
        );

        final expectedStates = [
          const OnboardingCubitState(status: OnboardingStatus.loading),
          const OnboardingCubitState(status: OnboardingStatus.completed),
        ];

        final future = expectLater(cubit.stream, emitsInOrder(expectedStates));
        await cubit.complete();
        await future;
        expect(repo.isCompleted, isTrue);
        cubit.close();
      },
    );

    test('emits error state on repository failure', () async {
      final repo = FakeOnboardingRepository(shouldThrow: true);
      final cubit = OnboardingCubit(
        hasCompletedOnboarding: HasCompletedOnboarding(repo),
        completeOnboarding: CompleteOnboarding(repo),
      );

      await cubit.checkOnboardingStatus();
      expect(cubit.state.status, equals(OnboardingStatus.error));
      expect(cubit.state.errorMessage, contains('Storage error'));
      cubit.close();
    });
  });
}
