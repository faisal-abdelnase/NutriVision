
import '../repositories/recipes_repository.dart';

class RemoveGroceryItem {
  RemoveGroceryItem(this.repository);

  final RecipesRepository repository;

  Future<void> call({
    required String userId,
    required String itemId,
  }) {
    return repository.removeGroceryItem(
      userId: userId,
      itemId: itemId,
    );
  }
}
