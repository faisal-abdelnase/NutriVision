
import '../repositories/recipes_repository.dart';

abstract class ClearGroceryList {
  final RecipesRepository repository;

  ClearGroceryList(this.repository);

  Future<void> call({
    required String userId,
  });
}