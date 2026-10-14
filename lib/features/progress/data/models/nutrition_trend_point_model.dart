import '../../domain/entities/nutrition_trend_point.dart';

class NutritionTrendPointModel extends NutritionTrendPoint {
  const NutritionTrendPointModel({
    required super.date,
    required super.calories,
    required super.proteinGrams,
    required super.carbohydrateGrams,
    required super.fatGrams,
    super.calorieTarget,
  });
}

abstract class NutritionTrendPointModelMapper {
  NutritionTrendPointModel fromJson(
    Map<String, dynamic> json,
  );

  Map<String, dynamic> toJson(
    NutritionTrendPointModel model,
  );

  
}