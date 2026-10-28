class MealAnalysisRequest {
  final String userId;

  final String? description;
  final String? imagePath;

  final String? mealType;
  final double? servingSizeGrams;

  final List<String> dietaryPreferences;
  final List<String> allergies;

  const MealAnalysisRequest({
    required this.userId,
    this.description,
    this.imagePath,
    this.mealType,
    this.servingSizeGrams,
    this.dietaryPreferences = const [],
    this.allergies = const [],
  });
}
