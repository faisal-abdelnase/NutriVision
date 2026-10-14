import '../../domain/entities/nutrition_advice.dart';

class NutritionAdviceModel extends NutritionAdvice {
  const NutritionAdviceModel({
    required super.id,
    required super.userId,
    required super.title,
    required super.content,
    required super.category,
    super.recommendations,
    super.warnings,
    super.referencedMealIds,
    required super.generatedAt,
    super.expiresAt,
    super.confidenceScore,
    super.conversationId,
  });
}

abstract class NutritionAdviceModelMapper {
  NutritionAdviceModel fromJson(
    Map<String, dynamic> json,
  );

  Map<String, dynamic> toJson(
    NutritionAdviceModel model,
  );

  
}