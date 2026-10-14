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
}

abstract class AnalyzedFoodItemModelMapper {
  AnalyzedFoodItemModel fromJson(
    Map<String, dynamic> json,
  );

  Map<String, dynamic> toJson(
    AnalyzedFoodItemModel model,
  );

}