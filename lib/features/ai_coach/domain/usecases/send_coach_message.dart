

import '../entities/coach_message.dart';
import '../repositories/ai_coach_repository.dart';

abstract class SendCoachMessage {
  final AiCoachRepository repository;

  SendCoachMessage(this.repository);

  Future<CoachMessage> call({
    required String userId,
    required String conversationId,
    required String message,
  });
}