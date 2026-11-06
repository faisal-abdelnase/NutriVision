import 'package:flutter_test/flutter_test.dart';
import 'package:nutri_vision/features/progress/data/models/nutrition_trend_point_model.dart';

void main() {
  test('preserves daily totals, meal count, and nullable profile targets', () {
    final point = NutritionTrendPointModel.fromJson({
      'date': '2026-11-05T00:00:00.000',
      'calories': 1200,
      'proteinGrams': 60,
      'carbohydrateGrams': 130,
      'fatGrams': 40,
      'calorieTarget': 2000,
      'proteinTargetGrams': 100,
      'carbohydrateTargetGrams': 220,
      'fatTargetGrams': 70,
      'mealCount': 2,
    });

    expect(point.calories, 1200);
    expect(point.proteinGrams, 60);
    expect(point.mealCount, 2);
    expect(point.calorieTarget, 2000);
    expect(point.carbohydrateTargetGrams, 220);
  });

  test('leaves absent nutrition targets unset', () {
    final point = NutritionTrendPointModel.fromJson({
      'date': '2026-11-05T00:00:00.000',
      'calories': 0,
      'proteinGrams': 0,
      'carbohydrateGrams': 0,
      'fatGrams': 0,
    });

    expect(point.calorieTarget, isNull);
    expect(point.proteinTargetGrams, isNull);
    expect(point.mealCount, 0);
  });
}
