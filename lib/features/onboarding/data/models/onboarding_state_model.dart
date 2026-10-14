import '../../domain/entities/onboarding_state.dart';

class OnboardingStateModel extends OnboardingState {
  const OnboardingStateModel({
    required super.isCompleted,
    super.completedAt,
  });

  // factory OnboardingStateModel.fromJson(
  //   Map<String, dynamic> json,
  // )

  // Map<String, dynamic> toJson(){}

  
}