import 'package:flutter_test/flutter_test.dart';
import 'package:nutri_vision/features/meal_tracking/data/models/meal_model.dart';

void main() {
  test('parses the saved meal document ID and nutrition fields', () {
    final meal = MealModel.fromJson({
      'userId': 'user-a',
      'name': 'Oats',
      'mealType': 'breakfast',
      'ingredients': [
        {'name': 'Oats', 'quantity': 50, 'unit': 'g'},
      ],
      'calories': 190,
      'proteinGrams': 7,
      'carbohydrateGrams': 32,
      'fatGrams': 4,
      'eatenAt': '2026-11-05T08:00:00.000',
      'createdAt': '2026-11-05T08:00:00.000',
    }, id: 'firestore-meal-id');

    expect(meal.id, 'firestore-meal-id');
    expect(meal.userId, 'user-a');
    expect(meal.calories, 190);
    expect(meal.ingredients.single.name, 'Oats');
    expect(meal.ingredients.single.quantity, 50);
  });
}
