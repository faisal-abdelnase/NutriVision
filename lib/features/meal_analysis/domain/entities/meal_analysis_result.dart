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
  final String? recipeDifficulty;
  final int? recipePreparationMinutes;
  final int? recipeCookingMinutes;
  final int? recipeServings;
  final List<String> recipeInstructions;
  final List<String> recipeSubstitutions;
  final double? totalFiberGrams;
  final bool isGeneratedRecipe;

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
    this.recipeDifficulty,
    this.recipePreparationMinutes,
    this.recipeCookingMinutes,
    this.recipeServings,
    this.recipeInstructions = const [],
    this.recipeSubstitutions = const [],
    this.totalFiberGrams,
    this.isGeneratedRecipe = false,
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
      recipeDifficulty: recipeDifficulty,
      recipePreparationMinutes: recipePreparationMinutes,
      recipeCookingMinutes: recipeCookingMinutes,
      recipeServings: recipeServings,
      recipeInstructions: recipeInstructions,
      recipeSubstitutions: recipeSubstitutions,
      totalFiberGrams: totalFiberGrams,
      isGeneratedRecipe: isGeneratedRecipe,
    );
  }
}
