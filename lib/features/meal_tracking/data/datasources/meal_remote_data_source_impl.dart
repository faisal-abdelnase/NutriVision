import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/meal_ingredient.dart';
import '../models/meal_ingredient_model.dart';
import '../models/meal_model.dart';
import 'meal_remote_data_source.dart';

class MealRemoteDataSourceImpl implements MealRemoteDataSource {
  final FirebaseFirestore firestore;

  MealRemoteDataSourceImpl({required this.firestore});

  CollectionReference<Map<String, dynamic>> _meals(String userId) {
    return firestore.collection('users').doc(userId).collection('meals');
  }

  List<MealIngredientModel> _mapIngredients(List<MealIngredient> ingredients) {
    return ingredients.map((ingredient) {
      return MealIngredientModel(
        name: ingredient.name,
        quantity: ingredient.quantity,
        unit: ingredient.unit,
        foodId: ingredient.foodId,
      );
    }).toList();
  }

  @override
  Future<MealModel> createMeal({required MealModel meal}) async {
    final collection = _meals(meal.userId);
    final document = meal.id.trim().isEmpty
        ? collection.doc()
        : collection.doc(meal.id);

    final now = DateTime.now();

    final createdMeal = MealModel(
      id: document.id,
      userId: meal.userId,
      name: meal.name,
      description: meal.description,
      mealType: meal.mealType,
      ingredients: _mapIngredients(meal.ingredients),
      calories: meal.calories,
      proteinGrams: meal.proteinGrams,
      carbohydrateGrams: meal.carbohydrateGrams,
      fatGrams: meal.fatGrams,
      eatenAt: meal.eatenAt,
      createdAt: now,
      updatedAt: null,
    );

    await document.set(createdMeal.toJson());

    return createdMeal;
  }

  @override
  Future<MealModel> updateMeal({required MealModel meal}) async {
    final document = _meals(meal.userId).doc(meal.id);
    final snapshot = await document.get();

    if (!snapshot.exists || snapshot.data() == null) {
      throw StateError('Meal not found.');
    }

    final existingData = snapshot.data()!;
    final createdAtValue = existingData['createdAt'];

    final originalCreatedAt = createdAtValue is Timestamp
        ? createdAtValue.toDate()
        : meal.createdAt;

    final updatedMeal = MealModel(
      id: meal.id,
      userId: meal.userId,
      name: meal.name,
      description: meal.description,
      mealType: meal.mealType,
      ingredients: _mapIngredients(meal.ingredients),
      calories: meal.calories,
      proteinGrams: meal.proteinGrams,
      carbohydrateGrams: meal.carbohydrateGrams,
      fatGrams: meal.fatGrams,
      eatenAt: meal.eatenAt,
      createdAt: originalCreatedAt,
      updatedAt: DateTime.now(),
    );

    await document.update(updatedMeal.toJson());

    return updatedMeal;
  }

  @override
  Future<void> deleteMeal({
    required String mealId,
    required String userId,
  }) async {
    final document = _meals(userId).doc(mealId);
    final snapshot = await document.get();

    if (!snapshot.exists) {
      throw StateError('Meal not found.');
    }

    await document.delete();
  }

  @override
  Future<MealModel?> fetchMealById({
    required String mealId,
    required String userId,
  }) async {
    final snapshot = await _meals(userId).doc(mealId).get();

    if (!snapshot.exists || snapshot.data() == null) {
      return null;
    }

    return MealModel.fromJson(snapshot.data()!, id: snapshot.id);
  }

  @override
  Future<List<MealModel>> fetchMealHistory({
    required String userId,
    required int page,
    required int pageSize,
  }) async {
    if (page < 0 || pageSize <= 0) {
      throw ArgumentError('page must be >= 0 and pageSize must be > 0.');
    }

    final snapshot = await _meals(
      userId,
    ).orderBy('eatenAt', descending: true).limit((page + 1) * pageSize).get();

    return snapshot.docs.skip(page * pageSize).map((document) {
      return MealModel.fromJson(document.data(), id: document.id);
    }).toList();
  }

  @override
  Future<List<MealModel>> fetchMealsByDate({
    required String userId,
    required DateTime date,
  }) async {
    final start = DateTime(date.year, date.month, date.day);
    final end = start.add(const Duration(days: 1));

    final snapshot = await _meals(userId)
        .where('eatenAt', isGreaterThanOrEqualTo: Timestamp.fromDate(start))
        .where('eatenAt', isLessThan: Timestamp.fromDate(end))
        .orderBy('eatenAt', descending: true)
        .get();

    return snapshot.docs.map((document) {
      return MealModel.fromJson(document.data(), id: document.id);
    }).toList();
  }
}
