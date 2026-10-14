class NutritionAdvice {
  final String id;
  final String userId;

  final String title;
  final String content;
  final String category;

  final List<String> recommendations;
  final List<String> warnings;

  final List<String> referencedMealIds;

  final DateTime generatedAt;
  final DateTime? expiresAt;

  final double? confidenceScore;
  final String? conversationId;

  const NutritionAdvice({
    required this.id,
    required this.userId,
    required this.title,
    required this.content,
    required this.category,
    this.recommendations = const [],
    this.warnings = const [],
    this.referencedMealIds = const [],
    required this.generatedAt,
    this.expiresAt,
    this.confidenceScore,
    this.conversationId,
  });
}