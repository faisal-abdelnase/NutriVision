import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/grocery_item.dart';
import '../../domain/entities/grocery_list.dart';
import 'grocery_item_model.dart';

class GroceryListModel extends GroceryList {
  const GroceryListModel({
    required super.userId,
    required List<GroceryItemModel> items,
    required super.updatedAt,
  }) : super(items: items);

  factory GroceryListModel.fromJson(Map<String, dynamic> json) {
    final rawItems = json['items'] as List<dynamic>? ?? [];
    final rawDate = json['updatedAt'];

    final DateTime date;
    if (rawDate is Timestamp) {
      date = rawDate.toDate();
    } else if (rawDate is DateTime) {
      date = rawDate;
    } else if (rawDate is String) {
      date = DateTime.parse(rawDate);
    } else if (rawDate is num) {
      date = DateTime.fromMillisecondsSinceEpoch(rawDate.toInt());
    } else {
      throw FormatException('Invalid grocery list updatedAt.');
    }

    return GroceryListModel(
      userId: json['userId'] as String,
      updatedAt: date,
      items: rawItems.map((item) {
        return GroceryItemModel.fromJson(
          Map<String, dynamic>.from(item as Map),
        );
      }).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'updatedAt': updatedAt.toIso8601String(),
      'items': items.map((item) {
        return (item as GroceryItemModel).toJson();
      }).toList(),
    };
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'updatedAt': Timestamp.fromDate(updatedAt),
      'items': items.map((item) {
        return (item as GroceryItemModel).toFirestore();
      }).toList(),
    };
  }

  List<GroceryItemModel> itemsToModels(List<GroceryItem> items) {
    return items.map((item) {
      if (item is GroceryItemModel) return item;

      return GroceryItemModel(
        id: item.id,
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
    }).toList();
  }
}
