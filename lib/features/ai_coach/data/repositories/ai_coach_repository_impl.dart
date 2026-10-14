

import '../../domain/entities/coach_message.dart';
import '../../domain/entities/coach_conversation.dart';
import '../../domain/entities/nutrition_advice.dart';
import '../../domain/repositories/ai_coach_repository.dart';

import '../datasources/ai_coach_remote_data_source.dart';
import '../datasources/ai_coach_local_data_source.dart';

abstract class AiCoachRepositoryImpl implements AiCoachRepository {
  final AiCoachRemoteDataSource remoteDataSource;
  final AiCoachLocalDataSource localDataSource;

  AiCoachRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<CoachMessage> sendMessage({
    required String userId,
    required String conversationId,
    required String message,
  });

  @override
  Future<List<CoachMessage>> getConversationHistory({
    required String userId,
    required String conversationId,
    required int page,
    required int pageSize,
  });

  @override
  Future<List<CoachConversation>> getUserConversations({
    required String userId,
    required int page,
    required int pageSize,
    required bool includeArchived,
  });

  @override
  Future<CoachConversation> createConversation({
    required String userId,
    required String title,
  });

  @override
  Future<void> deleteConversation({
    required String userId,
    required String conversationId,
  });

  @override
  Future<NutritionAdvice>
      getPersonalizedNutritionAdvice({
    required String userId,
    required List<String> dietaryPreferences,
    required List<String> allergies,
    required List<String> referencedMealIds,
    required String? goal,
  });
}