enum CoachMessageRole {
  user,
  assistant,
  system,
}

class CoachMessage {
  final String id;
  final String conversationId;
  final String userId;

  final CoachMessageRole role;
  final String content;

  final DateTime createdAt;

  final bool isNutritionAdvice;
  final List<String> referencedMealIds;

  final String? modelName;
  final int? promptTokens;
  final int? completionTokens;

  const CoachMessage({
    required this.id,
    required this.conversationId,
    required this.userId,
    required this.role,
    required this.content,
    required this.createdAt,
    this.isNutritionAdvice = false,
    this.referencedMealIds = const [],
    this.modelName,
    this.promptTokens,
    this.completionTokens,
  });
}