import '../../domain/entities/coach_conversation.dart';
import '../../domain/entities/coach_message.dart';
import '../../domain/entities/nutrition_advice.dart';
import '../../domain/repositories/ai_coach_repository.dart';
import '../../../../core/logging/ai_coach_diagnostics.dart';
import '../datasources/ai_coach_local_data_source.dart';
import '../datasources/ai_coach_remote_data_source.dart';
import '../models/coach_message_model.dart';

class AiCoachRepositoryImpl implements AiCoachRepository {
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
  }) async {
    final List<CoachMessageModel> context;
    try {
      context = await localDataSource.getCachedConversationMessages(
        conversationId: conversationId,
      );
    } catch (error, stackTrace) {
      AiCoachDiagnostics.failure(
        'Read conversation context from Hive',
        error,
        stackTrace,
        details: 'Firebase AI Logic request was not started.',
      );
      rethrow;
    }

    final CoachMessage response;
    try {
      response = await remoteDataSource.sendMessage(
        userId: userId,
        conversationId: conversationId,
        message: message,
        conversationContext: context,
      );
    } catch (error, stackTrace) {
      AiCoachDiagnostics.failure(
        'AI Coach remote data source sendMessage',
        error,
        stackTrace,
        details: 'Remote send failed; see data source diagnostics for stage.',
      );
      rethrow;
    }

    final userMessage = CoachMessageModel(
      id: 'local-${DateTime.now().microsecondsSinceEpoch}',
      conversationId: conversationId,
      userId: userId,
      role: CoachMessageRole.user,
      content: message.trim(),
      createdAt: DateTime.now(),
    );
    final assistantMessage = CoachMessageModel(
      id: response.id,
      conversationId: response.conversationId,
      userId: response.userId,
      role: response.role,
      content: response.content,
      createdAt: response.createdAt,
      isNutritionAdvice: response.isNutritionAdvice,
      referencedMealIds: response.referencedMealIds,
      modelName: response.modelName,
      promptTokens: response.promptTokens,
      completionTokens: response.completionTokens,
    );

    try {
      await localDataSource.cacheConversationMessages(
        conversationId: conversationId,
        messages: [...context, userMessage, assistantMessage]
          ..sort((a, b) => a.createdAt.compareTo(b.createdAt)),
      );
    } catch (error, stackTrace) {
      AiCoachDiagnostics.failure(
        'Cache sent conversation messages in Hive',
        error,
        stackTrace,
        details: 'Remote AI response was received; local cache write failed.',
      );
    }

    // The remote source already persists both messages in Firestore.
    // Refresh the local page so that Firestore-generated IDs are retained.
    try {
      final latest = await remoteDataSource.fetchConversationHistory(
        userId: userId,
        conversationId: conversationId,
        page: 1,
        pageSize: 20,
      );

      await localDataSource.cacheConversationMessages(
        conversationId: conversationId,
        messages: latest,
      );
    } catch (error, stackTrace) {
      AiCoachDiagnostics.failure(
        'Refresh sent conversation cache',
        error,
        stackTrace,
        details: 'Remote AI response was received; fallback cache is retained.',
      );
    }

    return response;
  }

  @override
  Future<List<CoachMessage>> getConversationHistory({
    required String userId,
    required String conversationId,
    required int page,
    required int pageSize,
  }) async {
    try {
      final remote = await remoteDataSource.fetchConversationHistory(
        userId: userId,
        conversationId: conversationId,
        page: page,
        pageSize: pageSize,
      );

      if (page == 1) {
        await localDataSource.cacheConversationMessages(
          conversationId: conversationId,
          messages: remote,
        );
      }

      return remote;
    } catch (_) {
      if (page == 1) {
        final cached = await localDataSource.getCachedConversationMessages(
          conversationId: conversationId,
        );

        if (cached.isNotEmpty) return cached;
      }

      rethrow;
    }
  }

  @override
  Future<List<CoachConversation>> getUserConversations({
    required String userId,
    required int page,
    required int pageSize,
    required bool includeArchived,
  }) async {
    try {
      final remote = await remoteDataSource.fetchUserConversations(
        userId: userId,
        page: page,
        pageSize: pageSize,
        includeArchived: includeArchived,
      );

      if (page == 1) {
        await localDataSource.cacheUserConversations(
          userId: userId,
          conversations: remote,
        );
      }

      return remote;
    } catch (_) {
      if (page == 1) {
        final cached = await localDataSource.getCachedUserConversations(
          userId: userId,
        );

        final filtered = includeArchived
            ? cached
            : cached.where((item) => !item.isArchived).toList();

        if (filtered.isNotEmpty) return filtered;
      }

      rethrow;
    }
  }

  @override
  Future<CoachConversation> createConversation({
    required String userId,
    required String title,
  }) async {
    final created = await remoteDataSource.createConversation(
      userId: userId,
      title: title,
    );

    final cached = await localDataSource.getCachedUserConversations(
      userId: userId,
    );

    await localDataSource.cacheUserConversations(
      userId: userId,
      conversations: [
        created,
        ...cached.where((item) => item.id != created.id),
      ],
    );

    return created;
  }

  @override
  Future<void> deleteConversation({
    required String userId,
    required String conversationId,
  }) async {
    await remoteDataSource.deleteConversation(
      userId: userId,
      conversationId: conversationId,
    );

    await localDataSource.clearConversationCache(
      conversationId: conversationId,
    );

    final cached = await localDataSource.getCachedUserConversations(
      userId: userId,
    );

    await localDataSource.cacheUserConversations(
      userId: userId,
      conversations: cached.where((item) => item.id != conversationId).toList(),
    );
  }

  @override
  Future<NutritionAdvice> getPersonalizedNutritionAdvice({
    required String userId,
    required List<String> dietaryPreferences,
    required List<String> allergies,
    required List<String> referencedMealIds,
    required String? goal,
  }) async {
    final advice = await remoteDataSource.fetchPersonalizedNutritionAdvice(
      userId: userId,
      dietaryPreferences: dietaryPreferences,
      allergies: allergies,
      referencedMealIds: referencedMealIds,
      goal: goal,
    );

    await localDataSource.cacheNutritionAdvice(advice: advice);

    return advice;
  }
}
