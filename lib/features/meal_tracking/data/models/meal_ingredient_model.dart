import '../../domain/entities/meal_ingredient.dart';

class MealIngredientModel extends MealIngredient {
  const MealIngredientModel({
    required super.name,
    required super.quantity,
    required super.unit,
    super.foodId,
  });

  factory MealIngredientModel.fromJson(Map<String, dynamic> json) {
    return MealIngredientModel(
      name: json['name'] as String,
      quantity: (json['quantity'] as num).toDouble(),
      unit: json['unit'] as String,
      foodId: json['foodId'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'quantity': quantity, 'unit': unit, 'foodId': foodId};
  }

  MealIngredientModel toIngredientModel(MealIngredient ingredient) {
    return MealIngredientModel(
      name: ingredient.name,
      quantity: ingredient.quantity,
      unit: ingredient.unit,
      foodId: ingredient.foodId,
    );
  }
}
