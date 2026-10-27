import 'package:nutri_vision/core/utils/formatters.dart';
import 'package:nutri_vision/features/meal_analysis/domain/entities/meal_analysis_result.dart';

/// Converts a confidence that may be 0..1 or 0..100 to 0..100.
double normalizePercent(double score) =>
    (score <= 1 ? score * 100 : score).clamp(0, 100);

String formatMetric(double value, {int decimals = 0}) =>
    value.toStringAsFixed(decimals);

/// Display values derived from a real [MealAnalysisResult].
class MealAnalysisSummary {
  const MealAnalysisSummary({
    required this.title,
    required this.mealType,
    required this.shortId,
    required this.confidencePercent,
    required this.totalWeightGrams,
    required this.proteinEnergyPercent,
    required this.carbEnergyPercent,
    required this.fatEnergyPercent,
  });

  factory MealAnalysisSummary.fromResult(MealAnalysisResult result) {
    final calories = result.totalCalories;
    final weight = result.foodItems
        .where((item) => item.quantityUnit.toLowerCase() == 'g')
        .fold<double>(0, (sum, item) => sum + item.estimatedQuantity);

    int energyPercent(double grams, double kcalPerGram) {
      if (calories <= 0) return 0;
      return (grams * kcalPerGram / calories * 100).round().clamp(0, 100);
    }

    final id = result.id;

    return MealAnalysisSummary(
      title: _titleFor(result),
      mealType: mealTypeFor(result.analyzedAt),
      shortId: (id.length > 6 ? id.substring(0, 6) : id).toUpperCase(),
      confidencePercent: result.confidenceScore == null
          ? null
          : normalizePercent(result.confidenceScore!),
      totalWeightGrams: weight,
      proteinEnergyPercent: energyPercent(result.totalProteinGrams, 4),
      carbEnergyPercent: energyPercent(result.totalCarbohydrateGrams, 4),
      fatEnergyPercent: energyPercent(result.totalFatGrams, 9),
    );
  }

  final String? title;
  final String mealType;
  final String shortId;
  final double? confidencePercent;
  final double totalWeightGrams;
  final int proteinEnergyPercent;
  final int carbEnergyPercent;
  final int fatEnergyPercent;

  String get mealTypeLabelKey => switch (mealType) {
    'breakfast' => 'mealAnalysisMealBreakfast',
    'lunch' => 'mealAnalysisMealLunch',
    'dinner' => 'mealAnalysisMealDinner',
    _ => 'mealAnalysisMealSnack',
  };

  static String mealTypeFor(DateTime time) {
    final hour = time.hour;
    if (hour < 11) return 'breakfast';
    if (hour < 16) return 'lunch';
    if (hour < 21) return 'dinner';
    return 'snack';
  }

  static String? _titleFor(MealAnalysisResult result) {
    final description = result.sourceDescription?.trim();
    if (description != null && description.isNotEmpty) {
      return Formatters.truncate(description, 48);
    }
    final names = result.foodItems
        .map((item) => item.name.trim())
        .where((name) => name.isNotEmpty)
        .take(2)
        .toList();
    return names.isEmpty ? null : names.join(', ');
  }
}
