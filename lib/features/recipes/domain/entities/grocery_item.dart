class GroceryItem {
  final String id;
  final String userId;
  final String name;

  final double quantity;
  final String unit;

  final bool isChecked;
  final String? recipeId;
  final String? recipeTitle;

  final String? category;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const GroceryItem({
    required this.id,
    required this.userId,
    required this.name,
    required this.quantity,
    required this.unit,
    this.isChecked = false,
    this.recipeId,
    this.recipeTitle,
    this.category,
    required this.createdAt,
    this.updatedAt,
  });

  GroceryItem copyWith({
    String? name,
    double? quantity,
    String? unit,
    bool? isChecked,
  }) {
    return GroceryItem(
      id: id,
      userId: userId,
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      unit: unit ?? this.unit,
      isChecked: isChecked ?? this.isChecked,
      recipeId: recipeId,
      recipeTitle: recipeTitle,
      category: category,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
    );
  }
}
