import '../models/coach_message_model.dart';
import '../models/coach_conversation_model.dart';
import '../models/nutrition_advice_model.dart';

abstract class AiCoachRemoteDataSource {
  Future<CoachMessageModel> sendMessage({
    required String userId,
    required String conversationId,
    required String message,
    required List<CoachMessageModel> conversationContext,
  });

  Future<List<CoachMessageModel>> fetchConversationHistory({
    required String userId,
    required String conversationId,
    required int page,
    required int pageSize,
  });

  Future<List<CoachConversationModel>> fetchUserConversations({
    required String userId,
    required int page,
    required int pageSize,
    required bool includeArchived,
  });

  Future<CoachConversationModel> createConversation({
    required String userId,
    required String title,
  });

  Future<void> deleteConversation({
    required String userId,
    required String conversationId,
  });

  Future<NutritionAdviceModel> fetchPersonalizedNutritionAdvice({
    required String userId,
    required List<String> dietaryPreferences,
    required List<String> allergies,
    required List<String> referencedMealIds,
    required String? goal,
  });
}
