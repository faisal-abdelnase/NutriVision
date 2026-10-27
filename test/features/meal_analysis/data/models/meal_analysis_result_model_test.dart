import 'package:flutter_test/flutter_test.dart';
import 'package:nutri_vision/features/meal_analysis/data/models/meal_analysis_result_model.dart';

void main() {
  group('MealAnalysisResultModel.fromJson', () {
    test('parses foodItems returned as a single object', () {
      final result = MealAnalysisResultModel.fromJson({
        'foodItems': {
          'name': 'Apple',
          'estimatedQuantity': 150,
          'quantityUnit': 'g',
          'calories': 78,
        },
      });

      expect(result.foodItems, hasLength(1));
      expect(result.foodItems.single.name, 'Apple');
      expect(result.foodItems.single.estimatedQuantity, 150);
    });

    test('preserves support for foodItems returned as a list', () {
      final result = MealAnalysisResultModel.fromJson({
        'foodItems': [
          {'name': 'Apple'},
          {'name': 'Banana'},
        ],
      });

      expect(
        result.foodItems.map((item) => item.name),
        ['Apple', 'Banana'],
      );
    });
  });
}
