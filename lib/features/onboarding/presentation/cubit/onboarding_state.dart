

enum OnboardingStatus {
  initial,
  loading,
  completed,
  notCompleted,
  error,
}

class OnboardingCubitState {
  final OnboardingStatus status;
  final String? errorMessage;

  const OnboardingCubitState({
    this.status = OnboardingStatus.initial,
    this.errorMessage,
  });

  bool get isLoading => status == OnboardingStatus.loading;

  bool get isCompleted => status == OnboardingStatus.completed;

  bool get hasError => status == OnboardingStatus.error;
}