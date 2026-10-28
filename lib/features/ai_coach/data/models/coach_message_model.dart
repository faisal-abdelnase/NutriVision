import 'package:cloud_firestore/cloud_firestore.dart';

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

  factory CoachMessageModel.fromJson(Map<String, dynamic> json) {
    final roleValue = json['role'] as String? ?? 'assistant';

    return CoachMessageModel(
      id: json['id'] as String,
      conversationId: json['conversationId'] as String,
      userId: json['userId'] as String,
      role: CoachMessageRole.values.firstWhere(
        (value) => value.name == roleValue,
        orElse: () => CoachMessageRole.assistant,
      ),
      content: json['content'] as String? ?? '',
      createdAt: _dateFromJson(json['createdAt']),
      isNutritionAdvice: json['isNutritionAdvice'] as bool? ?? false,
      referencedMealIds: List<String>.from(
        json['referencedMealIds'] ?? const [],
      ),
      modelName: json['modelName'] as String?,
      promptTokens: json['promptTokens'] as int?,
      completionTokens: json['completionTokens'] as int?,
    );
  }

  factory CoachMessageModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
  ) {
    final data = snapshot.data() ?? <String, dynamic>{};
    return CoachMessageModel.fromJson({...data, 'id': snapshot.id});
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'conversationId': conversationId,
    'userId': userId,
    'role': role.name,
    'content': content,
    'createdAt': createdAt.toIso8601String(),
    'isNutritionAdvice': isNutritionAdvice,
    'referencedMealIds': referencedMealIds,
    'modelName': modelName,
    'promptTokens': promptTokens,
    'completionTokens': completionTokens,
  };

  Map<String, dynamic> toFirestore() => {
    ...toJson(),
    'createdAt': Timestamp.fromDate(createdAt),
  };

  static DateTime _dateFromJson(dynamic value) {
    if (value is Timestamp) return value.toDate();
    if (value is DateTime) return value;
    if (value is String) return DateTime.parse(value);
    return DateTime.now();
  }
}
