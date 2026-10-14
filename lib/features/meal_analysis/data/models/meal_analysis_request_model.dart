import '../../domain/entities/meal_analysis_request.dart';

class MealAnalysisRequestModel extends MealAnalysisRequest {
  const MealAnalysisRequestModel({
    required super.userId,
    super.description,
    super.imagePath,
    super.mealType,
    super.servingSizeGrams,
    super.dietaryPreferences,
    super.allergies,
  });
}

abstract class MealAnalysisRequestModelMapper {
  MealAnalysisRequestModel fromJson(
    Map<String, dynamic> json,
  );

  Map<String, dynamic> toJson(
    MealAnalysisRequestModel model,
  );

  
}