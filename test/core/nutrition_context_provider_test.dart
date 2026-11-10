import 'package:flutter_test/flutter_test.dart';
import 'package:nutri_vision/core/nutrition_context/nutrition_context_provider.dart';

void main() {
  group('NutritionContextProvider calculations', () {
    test('sums actual meal calories and macronutrients', () {
      final totals = NutritionContextProvider.calculateTotals([
        {
          'calories': 620,
          'proteinGrams': 42,
          'carbohydrateGrams': 70,
          'fatGrams': 18,
        },
        {
          'calories': 380,
          'proteinGrams': 20,
          'carbohydrateGrams': 45,
          'fatGrams': 12,
        },
      ]);

      expect(totals['calories'], 1000);
      expect(totals['proteinGrams'], 62);
      expect(totals['carbohydrateGrams'], 115);
      expect(totals['fatGrams'], 30);
    });

    test('returns remaining goals and leaves missing targets unavailable', () {
      final remaining = NutritionContextProvider.remainingTargets(
        {
          'dailyCalorieTarget': 2000,
          'proteinTargetGrams': 120,
          'fatTargetGrams': 65,
        },
        {
          'calories': 1500,
          'proteinGrams': 80,
          'carbohydrateGrams': 100,
          'fatGrams': 50,
        },
      );

      expect(remaining['calories'], 500);
      expect(remaining['proteinGrams'], 40);
      expect(remaining['carbohydrateGrams'], isNull);
      expect(remaining['fatGrams'], 15);
    });

    test('empty history produces zero intake', () {
      expect(NutritionContextProvider.calculateTotals(const []), {
        'calories': 0,
        'proteinGrams': 0,
        'carbohydrateGrams': 0,
        'fatGrams': 0,
      });
    });

    test('historical questions select bounded date ranges', () {
      final today = DateTime(2026, 11, 10);
      final yesterday = NutritionContextProvider.historyRangeForQuestion(
        'What did I eat yesterday?',
        today,
      );
      final week = NutritionContextProvider.historyRangeForQuestion(
        'How many times did I eat pizza this week?',
        today,
      );

      expect(yesterday.$1, DateTime(2026, 11, 9));
      expect(yesterday.$2, today);
      expect(week.$1, DateTime(2026, 11, 4));
      expect(week.$2, today);
    });

    test('Arabic history questions are recognized', () {
      final yesterday = String.fromCharCodes([0x0623, 0x0645, 0x0633]);
      final question =
          '${String.fromCharCodes([0x0645, 0x0627, 0x0630, 0x0627])} $yesterday';
      expect(
        NutritionContextProvider.requiresHistoricalMeals(question),
        isTrue,
      );
    });
  });
}
