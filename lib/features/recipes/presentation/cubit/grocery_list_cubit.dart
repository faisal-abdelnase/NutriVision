
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/grocery_item.dart';
import '../../domain/repositories/recipes_repository.dart';
import 'grocery_list_state.dart';

class GroceryListCubit extends Cubit<GroceryListState> {
  GroceryListCubit(this._repository)
      : super(const GroceryListInitial());

  final RecipesRepository _repository;

  Future<void> load({required String userId}) async {
    emit(const GroceryListLoading());

    try {
      final list = await _repository.getGroceryList(
        userId: userId,
      );

      emit(GroceryListLoaded(list));
    } catch (error) {
      emit(GroceryListError('Failed to load grocery list: $error'));
    }
  }

  Future<void> addItem({required GroceryItem item}) async {
    try {
      await _repository.addGroceryItem(item: item);
      await load(userId: item.userId);
    } catch (error) {
      emit(GroceryListError('Failed to add item: $error'));
    }
  }

  Future<void> updateItem({required GroceryItem item}) async {
    try {
      await _repository.updateGroceryItem(item: item);
      await load(userId: item.userId);
    } catch (error) {
      emit(GroceryListError('Failed to update item: $error'));
    }
  }

  Future<void> removeItem({
    required String userId,
    required String itemId,
  }) async {
    try {
      await _repository.removeGroceryItem(
        userId: userId,
        itemId: itemId,
      );

      await load(userId: userId);
    } catch (error) {
      emit(GroceryListError('Failed to remove item: $error'));
    }
  }

  Future<void> clear({required String userId}) async {
    try {
      await _repository.clearGroceryList(userId: userId);
      await load(userId: userId);
    } catch (error) {
      emit(GroceryListError('Failed to clear grocery list: $error'));
    }
  }
}
