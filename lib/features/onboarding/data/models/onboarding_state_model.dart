import '../../domain/entities/onboarding_state.dart';

class OnboardingStateModel extends OnboardingState {
  const OnboardingStateModel({required super.isCompleted, super.completedAt});

  factory OnboardingStateModel.fromJson(Map<String, dynamic> json) {
    return OnboardingStateModel(
      isCompleted: json['isCompleted'] as bool? ?? false,
      completedAt: json['completedAt'] == null
          ? null
          : DateTime.tryParse(json['completedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'isCompleted': isCompleted,
      'completedAt': completedAt?.toIso8601String(),
    };
  }
}
