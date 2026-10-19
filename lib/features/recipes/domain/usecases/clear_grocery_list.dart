
import '../repositories/recipes_repository.dart';

class ClearGroceryList {
  ClearGroceryList(this.repository);

  final RecipesRepository repository;

  Future<void> call({required String userId}) {
    return repository.clearGroceryList(userId: userId);
  }
}
