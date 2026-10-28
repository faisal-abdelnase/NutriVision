import 'meal_ingredient.dart';

class Meal {
  final String id;
  final String userId;

  final String name;
  final String? description;
  final String mealType;

  final List<MealIngredient> ingredients;

  final double calories;
  final double proteinGrams;
  final double carbohydrateGrams;
  final double fatGrams;

  final DateTime eatenAt;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const Meal({
    required this.id,
    required this.userId,
    required this.name,
    this.description,
    required this.mealType,
    required this.ingredients,
    required this.calories,
    required this.proteinGrams,
    required this.carbohydrateGrams,
    required this.fatGrams,
    required this.eatenAt,
    required this.createdAt,
    this.updatedAt,
  });
}
