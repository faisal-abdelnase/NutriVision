import 'analyzed_food_item.dart';

class MealAnalysisResult {
  final String id;
  final String userId;

  final String? sourceDescription;
  final String? sourceImageUrl;

  final List<AnalyzedFoodItem> foodItems;

  final double totalCalories;
  final double totalProteinGrams;
  final double totalCarbohydrateGrams;
  final double totalFatGrams;

  final String? analysisSummary;
  final List<String> nutritionInsights;
  final List<String> warnings;

  final double? confidenceScore;

  final DateTime analyzedAt;
  final String? linkedMealId;

  const MealAnalysisResult({
    required this.id,
    required this.userId,
    this.sourceDescription,
    this.sourceImageUrl,
    required this.foodItems,
    required this.totalCalories,
    required this.totalProteinGrams,
    required this.totalCarbohydrateGrams,
    required this.totalFatGrams,
    this.analysisSummary,
    this.nutritionInsights = const [],
    this.warnings = const [],
    this.confidenceScore,
    required this.analyzedAt,
    this.linkedMealId,
  });
  MealAnalysisResult copyWith({String? linkedMealId}) {
    return MealAnalysisResult(
      id: id,
      userId: userId,
      sourceDescription: sourceDescription,
      sourceImageUrl: sourceImageUrl,
      foodItems: foodItems,
      totalCalories: totalCalories,
      totalProteinGrams: totalProteinGrams,
      totalCarbohydrateGrams: totalCarbohydrateGrams,
      totalFatGrams: totalFatGrams,
      analysisSummary: analysisSummary,
      nutritionInsights: nutritionInsights,
      warnings: warnings,
      confidenceScore: confidenceScore,
      analyzedAt: analyzedAt,
      linkedMealId: linkedMealId ?? this.linkedMealId,
    );
  }
}
