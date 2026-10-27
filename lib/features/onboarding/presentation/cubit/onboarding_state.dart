import 'package:equatable/equatable.dart';

enum OnboardingStatus { initial, loading, completed, notCompleted, error }

class OnboardingCubitState extends Equatable {
  final OnboardingStatus status;
  final String? errorMessage;

  const OnboardingCubitState({
    this.status = OnboardingStatus.initial,
    this.errorMessage,
  });

  bool get isLoading => status == OnboardingStatus.loading;

  bool get isCompleted => status == OnboardingStatus.completed;

  bool get hasError => status == OnboardingStatus.error;

  @override
  List<Object?> get props => [status, errorMessage];
}
