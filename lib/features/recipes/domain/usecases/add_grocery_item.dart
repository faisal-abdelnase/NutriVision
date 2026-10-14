

import '../entities/grocery_item.dart';
import '../repositories/recipes_repository.dart';

abstract class AddGroceryItem {
  final RecipesRepository repository;

  AddGroceryItem(this.repository);

  Future<GroceryItem> call({
    required GroceryItem item,
  });
}