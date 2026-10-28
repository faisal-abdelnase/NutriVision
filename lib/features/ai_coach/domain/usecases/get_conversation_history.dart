import '../entities/coach_message.dart';
import '../repositories/ai_coach_repository.dart';

class GetConversationHistory {
  final AiCoachRepository repository;

  GetConversationHistory(this.repository);

  Future<List<CoachMessage>> call({
    required String userId,
    required String conversationId,
    required int page,
    required int pageSize,
  }) {
    return repository.getConversationHistory(
      userId: userId,
      conversationId: conversationId,
      page: page,
      pageSize: pageSize,
    );
  }
}
