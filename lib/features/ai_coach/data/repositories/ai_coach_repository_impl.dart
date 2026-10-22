
import '../../domain/entities/coach_conversation.dart';
import '../../domain/entities/coach_message.dart';
import '../../domain/entities/nutrition_advice.dart';
import '../../domain/repositories/ai_coach_repository.dart';
import '../datasources/ai_coach_local_data_source.dart';
import '../datasources/ai_coach_remote_data_source.dart';


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
    final context = await localDataSource
        .getCachedConversationMessages(
      conversationId: conversationId,
    );

    final response = await remoteDataSource.sendMessage(
      userId: userId,
      conversationId: conversationId,
      message: message,
      conversationContext: context,
    );

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
    } catch (_) {
      // Keep the previous cache if refreshing it fails.
      // Do not turn a successful remote send into a failed send.
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
        final cached = await localDataSource
            .getCachedConversationMessages(
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
        final cached = await localDataSource
            .getCachedUserConversations(userId: userId);

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
      conversations: cached
          .where((item) => item.id != conversationId)
          .toList(),
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
    final advice =
        await remoteDataSource.fetchPersonalizedNutritionAdvice(
      userId: userId,
      dietaryPreferences: dietaryPreferences,
      allergies: allergies,
      referencedMealIds: referencedMealIds,
      goal: goal,
    );

    await localDataSource.cacheNutritionAdvice(
      advice: advice,
    );

    return advice;
  }
}
