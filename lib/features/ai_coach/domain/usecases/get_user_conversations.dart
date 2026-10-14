
import '../entities/coach_conversation.dart';
import '../repositories/ai_coach_repository.dart';

abstract class GetUserConversations {
  final AiCoachRepository repository;

  GetUserConversations(this.repository);

  Future<List<CoachConversation>> call({
    required String userId,
    required int page,
    required int pageSize,
    required bool includeArchived,
  });
}