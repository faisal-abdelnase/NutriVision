

import '../entities/nutrition_advice.dart';
import '../repositories/ai_coach_repository.dart';

abstract class GetPersonalizedNutritionAdvice {
  final AiCoachRepository repository;

  GetPersonalizedNutritionAdvice(this.repository);

  Future<NutritionAdvice> call({
    required String userId,
    required List<String> dietaryPreferences,
    required List<String> allergies,
    required List<String> referencedMealIds,
    required String? goal,
  });
}