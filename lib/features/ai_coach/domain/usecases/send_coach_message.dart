
import '../entities/coach_message.dart';
import '../repositories/ai_coach_repository.dart';

class SendCoachMessage {
  final AiCoachRepository repository;

  SendCoachMessage(this.repository);

  Future<CoachMessage> call({
    required String userId,
    required String conversationId,
    required String message,
  }) {
    return repository.sendMessage(
      userId: userId,
      conversationId: conversationId,
      message: message,
    );
  }
}
