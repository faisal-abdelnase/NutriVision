import 'package:nutri_vision/features/meal_analysis/domain/entities/meal_analysis_result.dart';

/// One insight row. Either backend [text] or localized keys with [params].
class MealInsight {
  const MealInsight.text(this.text, {this.isWarning = false})
    : titleKey = null,
      descriptionKey = null,
      params = const {};

  const MealInsight.localized({
    required this.titleKey,
    required this.descriptionKey,
    this.params = const {},
    this.isWarning = false,
  }) : text = null;

  final String? text;
  final String? titleKey;
  final String? descriptionKey;
  final Map<String, String> params;
  final bool isWarning;
}

/// Builds insight rows only from analysis data returned by the backend.
List<MealInsight> buildMealInsights(MealAnalysisResult result) {
  return [
    for (final text in result.nutritionInsights) MealInsight.text(text),
    for (final text in result.warnings) MealInsight.text(text, isWarning: true),
  ];
}
