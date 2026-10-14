

import '../repositories/ai_coach_repository.dart';

abstract class DeleteCoachConversation {
  final AiCoachRepository repository;

  DeleteCoachConversation(this.repository);

  Future<void> call({
    required String userId,
    required String conversationId,
  });
}