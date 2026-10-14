

import '../entities/coach_message.dart';
import '../entities/coach_conversation.dart';
import '../entities/nutrition_advice.dart';

abstract class AiCoachRepository {
  Future<CoachMessage> sendMessage({
    required String userId,
    required String conversationId,
    required String message,
  });

  Future<List<CoachMessage>> getConversationHistory({
    required String userId,
    required String conversationId,
    required int page,
    required int pageSize,
  });

  Future<List<CoachConversation>> getUserConversations({
    required String userId,
    required int page,
    required int pageSize,
    required bool includeArchived,
  });

  Future<CoachConversation> createConversation({
    required String userId,
    required String title,
  });

  Future<void> deleteConversation({
    required String userId,
    required String conversationId,
  });

  Future<NutritionAdvice>
      getPersonalizedNutritionAdvice({
    required String userId,
    required List<String> dietaryPreferences,
    required List<String> allergies,
    required List<String> referencedMealIds,
    required String? goal,
  });
}