
import '../repositories/recipes_repository.dart';

abstract class RemoveGroceryItem {
  final RecipesRepository repository;

  RemoveGroceryItem(this.repository);

  Future<void> call({
    required String userId,
    required String itemId,
  });
}