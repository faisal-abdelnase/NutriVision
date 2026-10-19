
import '../../domain/entities/grocery_list.dart';

abstract class GroceryListState {
  const GroceryListState();
}

class GroceryListInitial extends GroceryListState {
  const GroceryListInitial();
}

class GroceryListLoading extends GroceryListState {
  const GroceryListLoading();
}

class GroceryListLoaded extends GroceryListState {
  const GroceryListLoaded(this.groceryList);

  final GroceryList groceryList;
}

class GroceryListError extends GroceryListState {
  const GroceryListError(this.message);

  final String message;
}
