import '../../domain/entities/meal_ingredient.dart';

class MealIngredientModel extends MealIngredient {
  const MealIngredientModel({
    required super.name,
    required super.quantity,
    required super.unit,
    super.foodId,
  });
}

abstract class MealIngredientModelMapper {
  MealIngredientModel fromJson(
    Map<String, dynamic> json,
  );

  Map<String, dynamic> toJson(
    MealIngredientModel model,
  );

  
}