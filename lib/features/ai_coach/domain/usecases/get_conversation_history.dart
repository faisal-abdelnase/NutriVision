

import '../entities/coach_message.dart';
import '../repositories/ai_coach_repository.dart';

abstract class GetConversationHistory {
  final AiCoachRepository repository;

  GetConversationHistory(this.repository);

  Future<List<CoachMessage>> call({
    required String userId,
    required String conversationId,
    required int page,
    required int pageSize,
  });
}