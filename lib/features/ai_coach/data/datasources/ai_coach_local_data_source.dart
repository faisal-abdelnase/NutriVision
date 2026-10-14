import '../models/coach_message_model.dart';
import '../models/coach_conversation_model.dart';
import '../models/nutrition_advice_model.dart';

abstract class AiCoachLocalDataSource {
  Future<void> cacheConversationMessages({
    required String conversationId,
    required List<CoachMessageModel> messages,
  });

  Future<List<CoachMessageModel>> getCachedConversationMessages({
    required String conversationId,
  });

  Future<void> cacheUserConversations({
    required String userId,
    required List<CoachConversationModel> conversations,
  });

  Future<List<CoachConversationModel>> getCachedUserConversations({
    required String userId,
  });

  Future<void> cacheNutritionAdvice({
    required NutritionAdviceModel advice,
  });

  Future<NutritionAdviceModel?> getCachedNutritionAdvice({
    required String userId,
  });

  Future<void> clearConversationCache({
    required String conversationId,
  });

  Future<void> clearUserCoachCache({
    required String userId,
  });
}