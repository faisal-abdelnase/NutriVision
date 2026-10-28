import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/coach_conversation.dart';

class CoachConversationModel extends CoachConversation {
  const CoachConversationModel({
    required super.id,
    required super.userId,
    required super.title,
    required super.createdAt,
    required super.updatedAt,
    super.lastMessagePreview,
    super.lastMessageAt,
    super.isArchived,
  });

  factory CoachConversationModel.fromJson(Map<String, dynamic> json) {
    return CoachConversationModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      title: json['title'] as String? ?? 'New conversation',
      createdAt: _date(json['createdAt']),
      updatedAt: _date(json['updatedAt']),
      lastMessagePreview: json['lastMessagePreview'] as String?,
      lastMessageAt: json['lastMessageAt'] == null
          ? null
          : _date(json['lastMessageAt']),
      isArchived: json['isArchived'] as bool? ?? false,
    );
  }

  factory CoachConversationModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
  ) {
    return CoachConversationModel.fromJson({
      ...?snapshot.data(),
      'id': snapshot.id,
    });
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'userId': userId,
    'title': title,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
    'lastMessagePreview': lastMessagePreview,
    'lastMessageAt': lastMessageAt == null
        ? null
        : Timestamp.fromDate(lastMessageAt!),
    'isArchived': isArchived,
  };

  Map<String, dynamic> toFirestore() => {
    ...toJson(),
    'createdAt': Timestamp.fromDate(createdAt),
  };

  static DateTime _date(dynamic value) {
    if (value is Timestamp) return value.toDate();
    if (value is DateTime) return value;
    if (value is String) return DateTime.parse(value);
    return DateTime.now();
  }
}
