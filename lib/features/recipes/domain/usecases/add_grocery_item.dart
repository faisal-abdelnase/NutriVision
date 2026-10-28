import '../entities/grocery_item.dart';
import '../repositories/recipes_repository.dart';

class AddGroceryItem {
  AddGroceryItem(this.repository);

  final RecipesRepository repository;

  Future<GroceryItem> call({required GroceryItem item}) {
    return repository.addGroceryItem(item: item);
  }
}
