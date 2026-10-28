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

  factory MealAnalysisRequestModel.fromJson(Map<String, dynamic> json) {
    return MealAnalysisRequestModel(
      userId: json['userId'] as String,
      description: json['description'] as String?,
      imagePath: json['imagePath'] as String?,
      mealType: json['mealType'] as String?,
      servingSizeGrams: (json['servingSizeGrams'] as num?)?.toDouble(),
      dietaryPreferences: List<String>.from(
        json['dietaryPreferences'] ?? const [],
      ),
      allergies: List<String>.from(json['allergies'] ?? const []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'description': description,
      'imagePath': imagePath,
      'mealType': mealType,
      'servingSizeGrams': servingSizeGrams,
      'dietaryPreferences': dietaryPreferences,
      'allergies': allergies,
    };
  }
}
