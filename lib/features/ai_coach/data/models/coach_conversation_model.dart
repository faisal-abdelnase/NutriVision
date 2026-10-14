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
}

abstract class CoachConversationModelMapper {
  CoachConversationModel fromJson(
    Map<String, dynamic> json,
  );

  Map<String, dynamic> toJson(
    CoachConversationModel model,
  );

  
}