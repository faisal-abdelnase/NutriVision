
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/nutrition_trend_point.dart';

class NutritionTrendPointModel extends NutritionTrendPoint {
  const NutritionTrendPointModel({
    required super.date,
    required super.calories,
    required super.proteinGrams,
    required super.carbohydrateGrams,
    required super.fatGrams,
    super.calorieTarget,
  });

  factory NutritionTrendPointModel.fromJson(
    Map<String, dynamic> json,
  ) {
    DateTime parseDate(dynamic value) {
      if (value is Timestamp) return value.toDate();
      if (value is DateTime) return value;
      if (value is String) return DateTime.parse(value);

      throw FormatException('Invalid date value: $value');
    }

    double parseDouble(dynamic value) =>
        (value as num?)?.toDouble() ?? 0.0;

    return NutritionTrendPointModel(
      date: parseDate(json['date']),
      calories: parseDouble(json['calories']),
      proteinGrams: parseDouble(json['proteinGrams']),
      carbohydrateGrams: parseDouble(
        json['carbohydrateGrams'],
      ),
      fatGrams: parseDouble(json['fatGrams']),
      calorieTarget: json['calorieTarget'] == null
          ? null
          : parseDouble(json['calorieTarget']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': Timestamp.fromDate(date),
      'calories': calories,
      'proteinGrams': proteinGrams,
      'carbohydrateGrams': carbohydrateGrams,
      'fatGrams': fatGrams,
      'calorieTarget': calorieTarget,
    };
  }
}
