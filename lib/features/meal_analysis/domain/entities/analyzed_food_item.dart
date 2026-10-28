class AnalyzedFoodItem {
  final String name;
  final double estimatedQuantity;
  final String quantityUnit;

  final double calories;
  final double proteinGrams;
  final double carbohydrateGrams;
  final double fatGrams;

  final double? confidenceScore;
  final String? foodDatabaseId;

  const AnalyzedFoodItem({
    required this.name,
    required this.estimatedQuantity,
    required this.quantityUnit,
    required this.calories,
    required this.proteinGrams,
    required this.carbohydrateGrams,
    required this.fatGrams,
    this.confidenceScore,
    this.foodDatabaseId,
  });
}
