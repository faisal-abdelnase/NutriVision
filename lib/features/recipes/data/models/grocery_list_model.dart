import '../../domain/entities/grocery_list.dart';
import '../../domain/entities/grocery_item.dart';
import 'grocery_item_model.dart';

class GroceryListModel extends GroceryList {
  const GroceryListModel({
    required super.userId,
    required List<GroceryItemModel> items,
    required super.updatedAt,
  }) : super(items: items);
}

abstract class GroceryListModelMapper {
  GroceryListModel fromJson(
    Map<String, dynamic> json,
  );

  Map<String, dynamic> toJson(
    GroceryListModel model,
  );

  

  List<GroceryItemModel> itemsToModels(
    List<GroceryItem> items,
  );
}