
import '../entities/coach_conversation.dart';
import '../repositories/ai_coach_repository.dart';

abstract class CreateCoachConversation {
  final AiCoachRepository repository;

  CreateCoachConversation(this.repository);

  Future<CoachConversation> call({
    required String userId,
    required String title,
  });
}