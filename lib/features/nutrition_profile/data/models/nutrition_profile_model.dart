import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/nutrition_profile.dart';

class NutritionProfileModel extends NutritionProfile {
  const NutritionProfileModel({
    required super.userId,
    super.age,
    super.heightCm,
    super.weightKg,
    super.goal,
    super.dailyCalorieTarget,
    super.proteinTargetGrams,
    super.carbohydrateTargetGrams,
    super.fatTargetGrams,
    super.dietaryPreferences,
    super.allergies,
    super.updatedAt,
  });

  factory NutritionProfileModel.fromJson(Map<String, dynamic> json) {
    final dynamic timestamp = json['updatedAt'];

    return NutritionProfileModel(
      userId: json['userId'] as String,
      age: (json['age'] as num?)?.toInt(),
      heightCm: (json['heightCm'] as num?)?.toDouble(),
      weightKg: (json['weightKg'] as num?)?.toDouble(),
      goal: json['goal'] as String?,
      dailyCalorieTarget: (json['dailyCalorieTarget'] as num?)?.toDouble(),
      proteinTargetGrams: (json['proteinTargetGrams'] as num?)?.toDouble(),
      carbohydrateTargetGrams: (json['carbohydrateTargetGrams'] as num?)
          ?.toDouble(),
      fatTargetGrams: (json['fatTargetGrams'] as num?)?.toDouble(),
      dietaryPreferences: List<String>.from(
        json['dietaryPreferences'] ?? const [],
      ),
      allergies: List<String>.from(json['allergies'] ?? const []),
      updatedAt: _parseTimestamp(timestamp),
    );
  }

  factory NutritionProfileModel.fromEntity(NutritionProfile profile) {
    return NutritionProfileModel(
      userId: profile.userId,
      age: profile.age,
      heightCm: profile.heightCm,
      weightKg: profile.weightKg,
      goal: profile.goal,
      dailyCalorieTarget: profile.dailyCalorieTarget,
      proteinTargetGrams: profile.proteinTargetGrams,
      carbohydrateTargetGrams: profile.carbohydrateTargetGrams,
      fatTargetGrams: profile.fatTargetGrams,
      dietaryPreferences: List<String>.from(profile.dietaryPreferences),
      allergies: List<String>.from(profile.allergies),
      updatedAt: profile.updatedAt,
    );
  }

  static DateTime? _parseTimestamp(dynamic value) {
    if (value is Timestamp) {
      return value.toDate();
    }

    if (value is DateTime) {
      return value;
    }

    if (value is String) {
      return DateTime.tryParse(value);
    }

    return null;
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'age': age,
      'heightCm': heightCm,
      'weightKg': weightKg,
      'goal': goal,
      'dailyCalorieTarget': dailyCalorieTarget,
      'proteinTargetGrams': proteinTargetGrams,
      'carbohydrateTargetGrams': carbohydrateTargetGrams,
      'fatTargetGrams': fatTargetGrams,
      'dietaryPreferences': dietaryPreferences,
      'allergies': allergies,
      'updatedAt': Timestamp.fromDate(updatedAt ?? DateTime.now()),
    };
  }

  Map<String, dynamic> toLocalJson() {
    return {
      'userId': userId,
      'age': age,
      'heightCm': heightCm,
      'weightKg': weightKg,
      'goal': goal,
      'dailyCalorieTarget': dailyCalorieTarget,
      'proteinTargetGrams': proteinTargetGrams,
      'carbohydrateTargetGrams': carbohydrateTargetGrams,
      'fatTargetGrams': fatTargetGrams,
      'dietaryPreferences': dietaryPreferences,
      'allergies': allergies,
      'updatedAt': (updatedAt ?? DateTime.now()).toIso8601String(),
    };
  }
}
