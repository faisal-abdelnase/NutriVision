import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/grocery_item.dart';

class GroceryItemModel extends GroceryItem {
  const GroceryItemModel({
    required super.id,
    required super.userId,
    required super.name,
    required super.quantity,
    required super.unit,
    super.isChecked,
    super.recipeId,
    super.recipeTitle,
    super.category,
    required super.createdAt,
    super.updatedAt,
  });

  static DateTime _readDate(dynamic value) {
    if (value is Timestamp) return value.toDate();
    if (value is DateTime) return value;
    if (value is String) return DateTime.parse(value);
    if (value is num) {
      return DateTime.fromMillisecondsSinceEpoch(value.toInt());
    }
    throw FormatException('Invalid grocery item date: $value');
  }

  factory GroceryItemModel.fromJson(Map<String, dynamic> json) {
    return GroceryItemModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      name: json['name'] as String,
      quantity: (json['quantity'] as num).toDouble(),
      unit: json['unit'] as String,
      isChecked: json['isChecked'] as bool? ?? false,
      recipeId: json['recipeId'] as String?,
      recipeTitle: json['recipeTitle'] as String?,
      category: json['category'] as String?,
      createdAt: _readDate(json['createdAt']),
      updatedAt: json['updatedAt'] == null
          ? null
          : _readDate(json['updatedAt']),
    );
  }

  // JSON-compatible output for SharedPreferences.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'name': name,
      'quantity': quantity,
      'unit': unit,
      'isChecked': isChecked,
      'recipeId': recipeId,
      'recipeTitle': recipeTitle,
      'category': category,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  // Firestore-compatible output.
  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'userId': userId,
      'name': name,
      'quantity': quantity,
      'unit': unit,
      'isChecked': isChecked,
      'recipeId': recipeId,
      'recipeTitle': recipeTitle,
      'category': category,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': updatedAt == null ? null : Timestamp.fromDate(updatedAt!),
    };
  }
}
