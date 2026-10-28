import '../entities/grocery_list.dart';
import '../repositories/recipes_repository.dart';

class GetGroceryList {
  GetGroceryList(this.repository);

  final RecipesRepository repository;

  Future<GroceryList> call({required String userId}) {
    return repository.getGroceryList(userId: userId);
  }
}
