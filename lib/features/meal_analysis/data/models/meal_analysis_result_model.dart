import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/analyzed_food_item.dart';
import '../../domain/entities/meal_analysis_result.dart';
import 'analyzed_food_item_model.dart';

class MealAnalysisResultModel extends MealAnalysisResult {
  const MealAnalysisResultModel({
    required super.id,
    required super.userId,
    super.sourceDescription,
    super.sourceImageUrl,
    required List<AnalyzedFoodItemModel> foodItems,
    required super.totalCalories,
    required super.totalProteinGrams,
    required super.totalCarbohydrateGrams,
    required super.totalFatGrams,
    super.analysisSummary,
    super.nutritionInsights,
    super.warnings,
    super.confidenceScore,
    required super.analyzedAt,
    super.linkedMealId,
  }) : super(foodItems: foodItems);

  factory MealAnalysisResultModel.fromJson(
    Map<String, dynamic> json,
  ) {
    final rawDate = json['analyzedAt'];

    final DateTime analyzedAt;
    if (rawDate is Timestamp) {
      analyzedAt = rawDate.toDate();
    } else if (rawDate is DateTime) {
      analyzedAt = rawDate;
    } else if (rawDate is String) {
      analyzedAt = DateTime.parse(rawDate);
    } else {
      analyzedAt = DateTime.now();
    }

    return MealAnalysisResultModel(
      id: json['id'] as String? ?? '',
      userId: json['userId'] as String? ?? '',
      sourceDescription: json['sourceDescription'] as String?,
      sourceImageUrl: json['sourceImageUrl'] as String?,
      foodItems: (json['foodItems'] as List? ?? const [])
          .map(
            (item) => AnalyzedFoodItemModel.fromJson(
              Map<String, dynamic>.from(item as Map),
            ),
          )
          .toList(),
      totalCalories:
          (json['totalCalories'] as num?)?.toDouble() ?? 0,
      totalProteinGrams:
          (json['totalProteinGrams'] as num?)?.toDouble() ?? 0,
      totalCarbohydrateGrams:
          (json['totalCarbohydrateGrams'] as num?)?.toDouble() ?? 0,
      totalFatGrams:
          (json['totalFatGrams'] as num?)?.toDouble() ?? 0,
      analysisSummary: json['analysisSummary'] as String?,
      nutritionInsights:
          List<String>.from(json['nutritionInsights'] ?? const []),
      warnings: List<String>.from(json['warnings'] ?? const []),
      confidenceScore:
          (json['confidenceScore'] as num?)?.toDouble(),
      analyzedAt: analyzedAt,
      linkedMealId: json['linkedMealId'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'sourceDescription': sourceDescription,
      'sourceImageUrl': sourceImageUrl,
      'foodItems': foodItems
          .map(
            (item) => AnalyzedFoodItemModel(
              name: item.name,
              estimatedQuantity: item.estimatedQuantity,
              quantityUnit: item.quantityUnit,
              calories: item.calories,
              proteinGrams: item.proteinGrams,
              carbohydrateGrams: item.carbohydrateGrams,
              fatGrams: item.fatGrams,
              confidenceScore: item.confidenceScore,
              foodDatabaseId: item.foodDatabaseId,
            ).toJson(),
          )
          .toList(),
      'totalCalories': totalCalories,
      'totalProteinGrams': totalProteinGrams,
      'totalCarbohydrateGrams': totalCarbohydrateGrams,
      'totalFatGrams': totalFatGrams,
      'analysisSummary': analysisSummary,
      'nutritionInsights': nutritionInsights,
      'warnings': warnings,
      'confidenceScore': confidenceScore,
      'analyzedAt': Timestamp.fromDate(analyzedAt),
      'linkedMealId': linkedMealId,
    };
  }

  factory MealAnalysisResultModel.fromEntity(
    MealAnalysisResult result,
  ) {
    return MealAnalysisResultModel(
      id: result.id,
      userId: result.userId,
      sourceDescription: result.sourceDescription,
      sourceImageUrl: result.sourceImageUrl,
      foodItems: result.foodItems
          .map(
            (item) => AnalyzedFoodItemModel(
              name: item.name,
              estimatedQuantity: item.estimatedQuantity,
              quantityUnit: item.quantityUnit,
              calories: item.calories,
              proteinGrams: item.proteinGrams,
              carbohydrateGrams: item.carbohydrateGrams,
              fatGrams: item.fatGrams,
              confidenceScore: item.confidenceScore,
              foodDatabaseId: item.foodDatabaseId,
            ),
          )
          .toList(),
      totalCalories: result.totalCalories,
      totalProteinGrams: result.totalProteinGrams,
      totalCarbohydrateGrams: result.totalCarbohydrateGrams,
      totalFatGrams: result.totalFatGrams,
      analysisSummary: result.analysisSummary,
      nutritionInsights: result.nutritionInsights,
      warnings: result.warnings,
      confidenceScore: result.confidenceScore,
      analyzedAt: result.analyzedAt,
      linkedMealId: result.linkedMealId,
    );
  }
}