import '../entities/grocery_item.dart';
import '../repositories/recipes_repository.dart';

class UpdateGroceryItem {
  UpdateGroceryItem(this.repository);

  final RecipesRepository repository;

  Future<GroceryItem> call({required GroceryItem item}) {
    return repository.updateGroceryItem(item: item);
  }
}
