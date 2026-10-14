
import '../entities/grocery_item.dart';
import '../repositories/recipes_repository.dart';

abstract class UpdateGroceryItem {
  final RecipesRepository repository;

  UpdateGroceryItem(this.repository);

  Future<GroceryItem> call({
    required GroceryItem item,
  });
}