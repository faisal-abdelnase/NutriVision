
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/recipe_model.dart';
import 'recipes_remote_data_source.dart';
import 'recipe_generator_data_source.dart';

class RecipesRemoteDataSourceImpl
    implements RecipesRemoteDataSource {
  RecipesRemoteDataSourceImpl({
    required FirebaseFirestore firestore,
    required RecipeGeneratorDataSource recipeGenerator,
  })  : _firestore = firestore,
        _recipeGenerator = recipeGenerator;

  final FirebaseFirestore _firestore;
  final RecipeGeneratorDataSource _recipeGenerator;

  CollectionReference<Map<String, dynamic>> get _recipes =>
      _firestore.collection('recipes');

  CollectionReference<Map<String, dynamic>> _savedRecipes(
    String userId,
  ) =>
      _firestore
          .collection('users')
          .doc(userId)
          .collection('savedRecipes');

  RecipeModel _fromDocument(
    QueryDocumentSnapshot<Map<String, dynamic>> doc, {
    bool isSaved = false,
  }) {
    return RecipeModel.fromJson({
      ...doc.data(),
      'id': doc.id,
      'isSaved': isSaved,
    });
  }

  @override
  Future<List<RecipeModel>> fetchRecipes({
    required int page,
    required int pageSize,
    String? searchQuery,
    List<String>? tags,
    String? dietaryCategory,
  }) async {
    if (page < 1 || pageSize < 1) {
      throw ArgumentError('page and pageSize must be positive.');
    }

    final snapshot = await _recipes
        .orderBy('createdAt', descending: true)
        .get();

    var recipes = snapshot.docs
        .map((doc) => _fromDocument(doc))
        .toList();

    if (searchQuery != null && searchQuery.trim().isNotEmpty) {
      final query = searchQuery.trim().toLowerCase();

      recipes = recipes.where((recipe) {
        return recipe.title.toLowerCase().contains(query) ||
            recipe.description.toLowerCase().contains(query);
      }).toList();
    }

    if (tags != null && tags.isNotEmpty) {
      recipes = recipes.where((recipe) {
        return tags.any(recipe.tags.contains);
      }).toList();
    }

    if (dietaryCategory != null &&
        dietaryCategory.trim().isNotEmpty) {
      recipes = recipes.where((recipe) {
        return recipe.dietaryCategory == dietaryCategory;
      }).toList();
    }

    final start = (page - 1) * pageSize;
    if (start >= recipes.length) return [];

    final end = (start + pageSize).clamp(0, recipes.length);
    return recipes.sublist(start, end);
  }

  @override
  Future<RecipeModel?> fetchRecipeById({
    required String recipeId,
  }) async {
    final doc = await _recipes.doc(recipeId).get();
    if (!doc.exists) return null;

    final data = doc.data();
    if (data == null) return null;

    return RecipeModel.fromJson({
      ...data,
      'id': doc.id,
    });
  }

  @override
  Future<RecipeModel> generatePersonalizedRecipe({
    required String userId,
    required List<String> availableIngredients,
    required List<String> dietaryPreferences,
    required List<String> allergies,
    required String? goal,
    required int servings,
  }) {
    return _recipeGenerator.generate(
      userId: userId,
      availableIngredients: availableIngredients,
      dietaryPreferences: dietaryPreferences,
      allergies: allergies,
      goal: goal,
      servings: servings,
    );
  }

  @override
  Future<void> saveRecipe({
    required String userId,
    required String recipeId,
  }) async {
    final recipe = await _recipes.doc(recipeId).get();

    if (!recipe.exists) {
      throw StateError('Recipe does not exist: $recipeId');
    }

    await _savedRecipes(userId).doc(recipeId).set({
      'recipeId': recipeId,
      'savedAt': FieldValue.serverTimestamp(),
    });
  }

  @override
  Future<void> removeSavedRecipe({
    required String userId,
    required String recipeId,
  }) async {
    await _savedRecipes(userId).doc(recipeId).delete();
  }

  @override
  Future<List<RecipeModel>> fetchSavedRecipes({
    required String userId,
    required int page,
    required int pageSize,
  }) async {
    if (page < 1 || pageSize < 1) {
      throw ArgumentError('page and pageSize must be positive.');
    }

    final savedSnapshot = await _savedRecipes(userId)
        .orderBy('savedAt', descending: true)
        .get();

    final start = (page - 1) * pageSize;
    if (start >= savedSnapshot.docs.length) return [];

    final end = (start + pageSize).clamp(
      0,
      savedSnapshot.docs.length,
    );

    final pageDocs = savedSnapshot.docs.sublist(start, end);
    final result = <RecipeModel>[];

    for (final savedDoc in pageDocs) {
      final recipeId =
          savedDoc.data()['recipeId'] as String? ?? savedDoc.id;

      final recipe = await _recipes.doc(recipeId).get();
      final data = recipe.data();

      if (!recipe.exists || data == null) continue;

      result.add(
        RecipeModel.fromJson({
          ...data,
          'id': recipe.id,
          'isSaved': true,
        }),
      );
    }

    return result;
  }
}
