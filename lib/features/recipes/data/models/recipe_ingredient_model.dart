import '../../domain/entities/recipe_ingredient.dart';

class RecipeIngredientModel extends RecipeIngredient {
  const RecipeIngredientModel({
    required super.id,
    required super.name,
    required super.quantity,
    required super.unit,
    super.isOptional,
    super.foodDatabaseId,
  });
}

abstract class RecipeIngredientModelMapper {
  RecipeIngredientModel fromJson(
    Map<String, dynamic> json,
  );

  Map<String, dynamic> toJson(
    RecipeIngredientModel model,
  );

  
}