import '../../domain/entities/grocery_item.dart';

class GroceryItemModel extends GroceryItem {
  const GroceryItemModel({
    required super.id,
    required super.userId,
    required super.name,
    required super.quantity,
    required super.unit,
    super.isChecked,
    super.recipeId,
    super.recipeTitle,
    super.category,
    required super.createdAt,
    super.updatedAt,
  });
}

abstract class GroceryItemModelMapper {
  GroceryItemModel fromJson(
    Map<String, dynamic> json,
  );

  Map<String, dynamic> toJson(
    GroceryItemModel model,
  );

  
}