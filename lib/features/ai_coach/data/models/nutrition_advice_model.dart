
import 'package:cloud_firestore/cloud_firestore.dart';

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

  factory NutritionAdviceModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return NutritionAdviceModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      title: json['title'] as String? ?? 'Nutrition advice',
      content: json['content'] as String? ?? '',
      category: json['category'] as String? ?? 'general',
      recommendations:
          List<String>.from(json['recommendations'] ?? const []),
      warnings: List<String>.from(json['warnings'] ?? const []),
      referencedMealIds:
          List<String>.from(json['referencedMealIds'] ?? const []),
      generatedAt: _date(json['generatedAt']),
      expiresAt: json['expiresAt'] == null
          ? null
          : _date(json['expiresAt']),
      confidenceScore: (json['confidenceScore'] as num?)?.toDouble(),
      conversationId: json['conversationId'] as String?,
    );
  }

  factory NutritionAdviceModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
  ) {
    return NutritionAdviceModel.fromJson({
      ...?snapshot.data(),
      'id': snapshot.id,
    });
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'title': title,
        'content': content,
        'category': category,
        'recommendations': recommendations,
        'warnings': warnings,
        'referencedMealIds': referencedMealIds,
        'generatedAt': generatedAt.toIso8601String(),
        'expiresAt': expiresAt?.toIso8601String(),
        'confidenceScore': confidenceScore,
        'conversationId': conversationId,
      };

  
Map<String, dynamic> toFirestore() => {
  ...toJson(),
  'createdAt': Timestamp.fromDate(generatedAt),
};


  static DateTime _date(dynamic value) {
    if (value is Timestamp) return value.toDate();
    if (value is DateTime) return value;
    if (value is String) return DateTime.parse(value);
    return DateTime.now();
  }
}
