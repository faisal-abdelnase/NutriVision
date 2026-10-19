
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

  factory RecipeIngredientModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return RecipeIngredientModel(
      id: json['id'] as String,
      name: json['name'] as String,
      quantity: (json['quantity'] as num).toDouble(),
      unit: json['unit'] as String,
      isOptional: json['isOptional'] as bool? ?? false,
      foodDatabaseId: json['foodDatabaseId'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'quantity': quantity,
      'unit': unit,
      'isOptional': isOptional,
      'foodDatabaseId': foodDatabaseId,
    };
  }
}
