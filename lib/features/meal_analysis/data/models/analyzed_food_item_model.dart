import '../../domain/entities/analyzed_food_item.dart';

class AnalyzedFoodItemModel extends AnalyzedFoodItem {
  const AnalyzedFoodItemModel({
    required super.name,
    required super.estimatedQuantity,
    required super.quantityUnit,
    required super.calories,
    required super.proteinGrams,
    required super.carbohydrateGrams,
    required super.fatGrams,
    super.confidenceScore,
    super.foodDatabaseId,
  });

  factory AnalyzedFoodItemModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return AnalyzedFoodItemModel(
      name: json['name'] as String? ?? '',
      estimatedQuantity:
          (json['estimatedQuantity'] as num?)?.toDouble() ?? 0,
      quantityUnit: json['quantityUnit'] as String? ?? 'g',
      calories: (json['calories'] as num?)?.toDouble() ?? 0,
      proteinGrams:
          (json['proteinGrams'] as num?)?.toDouble() ?? 0,
      carbohydrateGrams:
          (json['carbohydrateGrams'] as num?)?.toDouble() ?? 0,
      fatGrams: (json['fatGrams'] as num?)?.toDouble() ?? 0,
      confidenceScore:
          (json['confidenceScore'] as num?)?.toDouble(),
      foodDatabaseId: json['foodDatabaseId'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'estimatedQuantity': estimatedQuantity,
      'quantityUnit': quantityUnit,
      'calories': calories,
      'proteinGrams': proteinGrams,
      'carbohydrateGrams': carbohydrateGrams,
      'fatGrams': fatGrams,
      'confidenceScore': confidenceScore,
      'foodDatabaseId': foodDatabaseId,
    };
  }
}