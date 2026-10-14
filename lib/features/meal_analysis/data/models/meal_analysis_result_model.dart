import '../../domain/entities/analyzed_food_item.dart';
import '../../domain/entities/meal_analysis_result.dart';
import 'analyzed_food_item_model.dart';

class MealAnalysisResultModel extends MealAnalysisResult {
  const MealAnalysisResultModel({
    required super.id,
    required super.userId,
    super.sourceDescription,
    super.sourceImageUrl,
    required List<AnalyzedFoodItemModel> foodItems,
    required super.totalCalories,
    required super.totalProteinGrams,
    required super.totalCarbohydrateGrams,
    required super.totalFatGrams,
    super.analysisSummary,
    super.nutritionInsights,
    super.warnings,
    super.confidenceScore,
    required super.analyzedAt,
    super.linkedMealId,
  }) : super(foodItems: foodItems);
}

abstract class MealAnalysisResultModelMapper {
  MealAnalysisResultModel fromJson(
    Map<String, dynamic> json,
  );

  Map<String, dynamic> toJson(
    MealAnalysisResultModel model,
  );

  

  List<AnalyzedFoodItemModel> foodItemsToModels(
    List<AnalyzedFoodItem> foodItems,
  );
}