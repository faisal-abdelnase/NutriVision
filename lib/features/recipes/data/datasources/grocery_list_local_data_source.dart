import '../models/grocery_item_model.dart';
import '../models/grocery_list_model.dart';

abstract interface class GroceryListLocalDataSource {
  Future<GroceryListModel?> readGroceryList({required String userId});

  Future<GroceryListModel> saveGroceryList({
    required GroceryListModel groceryList,
  });

  Future<GroceryItemModel> addGroceryItem({required GroceryItemModel item});

  Future<GroceryItemModel> updateGroceryItem({required GroceryItemModel item});

  Future<void> removeGroceryItem({
    required String userId,
    required String itemId,
  });

  Future<void> clearGroceryList({required String userId});
}
