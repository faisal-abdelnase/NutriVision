import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../models/grocery_item_model.dart';
import '../models/grocery_list_model.dart';
import 'grocery_list_local_data_source.dart';

class GroceryListLocalDataSourceImpl implements GroceryListLocalDataSource {
  GroceryListLocalDataSourceImpl(this._preferences);

  final SharedPreferences _preferences;
  final Uuid _uuid = const Uuid();

  String _key(String userId) => 'grocery_list_$userId';

  @override
  Future<GroceryListModel?> readGroceryList({required String userId}) async {
    final raw = _preferences.getString(_key(userId));
    if (raw == null) return null;

    return GroceryListModel.fromJson(
      Map<String, dynamic>.from(jsonDecode(raw) as Map),
    );
  }

  @override
  Future<GroceryListModel> saveGroceryList({
    required GroceryListModel groceryList,
  }) async {
    final normalized = GroceryListModel(
      userId: groceryList.userId,
      items: groceryList.items
          .map((item) => groceryList.itemsToModels([item]).first)
          .toList(),
      updatedAt: DateTime.now(),
    );

    await _preferences.setString(
      _key(normalized.userId),
      jsonEncode(normalized.toJson()),
    );

    return normalized;
  }

  @override
  Future<GroceryItemModel> addGroceryItem({
    required GroceryItemModel item,
  }) async {
    final current = await readGroceryList(userId: item.userId);

    final items =
        current?.items.map((entry) => entry as GroceryItemModel).toList() ??
        <GroceryItemModel>[];

    final newItem = GroceryItemModel(
      id: item.id.isEmpty ? _uuid.v4() : item.id,
      userId: item.userId,
      name: item.name,
      quantity: item.quantity,
      unit: item.unit,
      isChecked: item.isChecked,
      recipeId: item.recipeId,
      recipeTitle: item.recipeTitle,
      category: item.category,
      createdAt: item.createdAt,
      updatedAt: item.updatedAt,
    );

    items.add(newItem);

    await saveGroceryList(
      groceryList: GroceryListModel(
        userId: item.userId,
        items: items,
        updatedAt: DateTime.now(),
      ),
    );

    return newItem;
  }

  @override
  Future<GroceryItemModel> updateGroceryItem({
    required GroceryItemModel item,
  }) async {
    final current = await readGroceryList(userId: item.userId);

    if (current == null) {
      throw StateError('Grocery list does not exist.');
    }

    final items = current.items
        .map((entry) => entry as GroceryItemModel)
        .toList();

    final index = items.indexWhere((entry) => entry.id == item.id);

    if (index == -1) {
      throw StateError('Grocery item not found.');
    }

    items[index] = item;

    await saveGroceryList(
      groceryList: GroceryListModel(
        userId: item.userId,
        items: items,
        updatedAt: DateTime.now(),
      ),
    );

    return item;
  }

  @override
  Future<void> removeGroceryItem({
    required String userId,
    required String itemId,
  }) async {
    final current = await readGroceryList(userId: userId);
    if (current == null) return;

    final items = current.items
        .where((entry) => entry.id != itemId)
        .map((entry) => entry as GroceryItemModel)
        .toList();

    await saveGroceryList(
      groceryList: GroceryListModel(
        userId: userId,
        items: items,
        updatedAt: DateTime.now(),
      ),
    );
  }

  @override
  Future<void> clearGroceryList({required String userId}) async {
    await _preferences.remove(_key(userId));
  }
}
