

import '../entities/grocery_list.dart';
import '../repositories/recipes_repository.dart';

abstract class GetGroceryList {
  final RecipesRepository repository;

  GetGroceryList(this.repository);

  Future<GroceryList> call({
    required String userId,
  });
}