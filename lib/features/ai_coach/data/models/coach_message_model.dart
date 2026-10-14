import '../../domain/entities/coach_message.dart';

class CoachMessageModel extends CoachMessage {
  const CoachMessageModel({
    required super.id,
    required super.conversationId,
    required super.userId,
    required super.role,
    required super.content,
    required super.createdAt,
    super.isNutritionAdvice,
    super.referencedMealIds,
    super.modelName,
    super.promptTokens,
    super.completionTokens,
  });
}

abstract class CoachMessageModelMapper {
  CoachMessageModel fromJson(
    Map<String, dynamic> json,
  );

  Map<String, dynamic> toJson(
    CoachMessageModel model,
  );

  
}