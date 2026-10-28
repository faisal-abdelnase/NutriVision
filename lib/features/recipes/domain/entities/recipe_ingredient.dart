class RecipeIngredient {
  final String id;
  final String name;
  final double quantity;
  final String unit;
  final bool isOptional;
  final String? foodDatabaseId;

  const RecipeIngredient({
    required this.id,
    required this.name,
    required this.quantity,
    required this.unit,
    this.isOptional = false,
    this.foodDatabaseId,
  });
}
