import '../../domain/entities/meal.dart';
import '../../domain/entities/meal_ingredient.dart';
import 'meal_ingredient_model.dart';

class MealModel extends Meal {
  const MealModel({
    required super.id,
    required super.userId,
    required super.name,
    super.description,
    required super.mealType,
    required List<MealIngredientModel> ingredients,
    required super.calories,
    required super.proteinGrams,
    required super.carbohydrateGrams,
    required super.fatGrams,
    required super.eatenAt,
    required super.createdAt,
    super.updatedAt,
  }) : super(ingredients: ingredients);
}

abstract class MealModelMapper {
  MealModel fromJson(
    Map<String, dynamic> json,
  );

  Map<String, dynamic> toJson(
    MealModel model,
  );


  List<MealIngredientModel> ingredientsToModels(
    List<MealIngredient> ingredients,
  );
}