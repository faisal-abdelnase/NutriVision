import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/meal.dart';
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

  factory MealModel.fromJson(Map<String, dynamic> json, {required String id}) {
    DateTime parseDate(dynamic value) {
      if (value is Timestamp) return value.toDate();
      if (value is DateTime) return value;
      if (value is String) return DateTime.parse(value);

      throw FormatException('Invalid meal date: $value');
    }

    final rawIngredients = json['ingredients'] as List? ?? [];

    return MealModel(
      id: id,
      userId: json['userId'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      mealType: json['mealType'] as String,
      ingredients: rawIngredients.map((item) {
        return MealIngredientModel.fromJson(
          Map<String, dynamic>.from(item as Map),
        );
      }).toList(),
      calories: (json['calories'] as num).toDouble(),
      proteinGrams: (json['proteinGrams'] as num).toDouble(),
      carbohydrateGrams: (json['carbohydrateGrams'] as num).toDouble(),
      fatGrams: (json['fatGrams'] as num).toDouble(),
      eatenAt: parseDate(json['eatenAt']),
      createdAt: parseDate(json['createdAt']),
      updatedAt: json['updatedAt'] == null
          ? null
          : parseDate(json['updatedAt']),
    );
  }

  factory MealModel.fromEntity(Meal meal) {
    return MealModel(
      id: meal.id,
      userId: meal.userId,
      name: meal.name,
      description: meal.description,
      mealType: meal.mealType,
      ingredients: meal.ingredients
          .map(
            (ingredient) => MealIngredientModel(
              name: ingredient.name,
              quantity: ingredient.quantity,
              unit: ingredient.unit,
              foodId: ingredient.foodId,
            ),
          )
          .toList(),
      calories: meal.calories,
      proteinGrams: meal.proteinGrams,
      carbohydrateGrams: meal.carbohydrateGrams,
      fatGrams: meal.fatGrams,
      eatenAt: meal.eatenAt,
      createdAt: meal.createdAt,
      updatedAt: meal.updatedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'name': name,
      'description': description,
      'mealType': mealType,
      'ingredients': ingredients
          .map(
            (ingredient) => MealIngredientModel(
              name: ingredient.name,
              quantity: ingredient.quantity,
              unit: ingredient.unit,
              foodId: ingredient.foodId,
            ).toJson(),
          )
          .toList(),
      'calories': calories,
      'proteinGrams': proteinGrams,
      'carbohydrateGrams': carbohydrateGrams,
      'fatGrams': fatGrams,
      'eatenAt': Timestamp.fromDate(eatenAt),
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': updatedAt == null ? null : Timestamp.fromDate(updatedAt!),
    };
  }
}
