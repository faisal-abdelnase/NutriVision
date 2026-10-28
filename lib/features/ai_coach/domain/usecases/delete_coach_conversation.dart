import '../repositories/ai_coach_repository.dart';

class DeleteCoachConversation {
  final AiCoachRepository repository;

  DeleteCoachConversation(this.repository);

  Future<void> call({required String userId, required String conversationId}) {
    return repository.deleteConversation(
      userId: userId,
      conversationId: conversationId,
    );
  }
}
