import 'grocery_item.dart';

class GroceryList {
  final String userId;
  final List<GroceryItem> items;
  final DateTime updatedAt;

  const GroceryList({
    required this.userId,
    required this.items,
    required this.updatedAt,
  });
}