class MealIngredient {
  final String name;
  final double quantity;
  final String unit;
  final String? foodId;

  const MealIngredient({
    required this.name,
    required this.quantity,
    required this.unit,
    this.foodId,
  });
}