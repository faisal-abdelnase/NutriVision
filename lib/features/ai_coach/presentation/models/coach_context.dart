import 'package:flutter/foundation.dart';

import '../../../dashboard/domain/entities/daily_nutrition_summary.dart';
import '../../../dashboard/domain/entities/recent_meal_summary.dart';
import '../../../nutrition_profile/domain/entities/nutrition_profile.dart';

enum CoachContextStatus { loading, ready, error }

/// Read-only snapshot of the user's day shown next to the chat. It is built
/// from the existing Dashboard and NutritionProfile features.
@immutable
class CoachContext {
  const CoachContext({
    required this.status,
    required this.onRetry,
    this.summary,
    this.profile,
    this.recentMeals = const [],
  });

  final CoachContextStatus status;
  final DailyNutritionSummary? summary;
  final NutritionProfile? profile;
  final List<RecentMealSummary> recentMeals;
  final VoidCallback onRetry;

  bool get isReady => status == CoachContextStatus.ready;

  double get consumedCalories => summary?.consumedCalories ?? 0;
  double get consumedProtein => summary?.consumedProteinGrams ?? 0;
  double get consumedCarbs => summary?.consumedCarbohydrateGrams ?? 0;
  double get consumedFat => summary?.consumedFatGrams ?? 0;

  /// The daily target stored with the user wins; the nutrition profile is the
  /// fallback. `null` means the user has not set one.
  double? get calorieTarget =>
      _positive(summary?.calorieTarget) ??
      _positive(profile?.dailyCalorieTarget);

  double? get proteinTarget => _positive(profile?.proteinTargetGrams);
  double? get carbsTarget => _positive(profile?.carbohydrateTargetGrams);
  double? get fatTarget => _positive(profile?.fatTargetGrams);

  int? get caloriePercent {
    final target = calorieTarget;
    if (target == null) return null;
    return (consumedCalories / target * 100).round();
  }

  static double? _positive(double? value) =>
      (value != null && value > 0) ? value : null;
}
