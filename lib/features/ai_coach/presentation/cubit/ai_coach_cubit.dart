import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/coach_conversation.dart';
import '../../domain/entities/coach_message.dart';
import '../../domain/usecases/create_coach_conversation.dart';
import '../../domain/usecases/delete_coach_conversation.dart';
import '../../domain/usecases/get_conversation_history.dart';
import '../../domain/usecases/get_personalized_nutrition_advice.dart';
import '../../domain/usecases/get_user_conversations.dart';
import '../../domain/usecases/send_coach_message.dart';
import 'ai_coach_state.dart';

class AiCoachCubit extends Cubit<AiCoachState> {
  final SendCoachMessage sendCoachMessage;
  final GetConversationHistory getConversationHistory;
  final GetUserConversations getUserConversations;
  final CreateCoachConversation createCoachConversation;
  final DeleteCoachConversation deleteCoachConversation;
  final GetPersonalizedNutritionAdvice getNutritionAdvice;

  AiCoachCubit({
    required this.sendCoachMessage,
    required this.getConversationHistory,
    required this.getUserConversations,
    required this.createCoachConversation,
    required this.deleteCoachConversation,
    required this.getNutritionAdvice,
  }) : super(const AiCoachState());

  static const int pageSize = 20;

  /// Prefix of ids given to messages that exist only on the device until the
  /// server copy is fetched.
  static const String localMessagePrefix = 'local-';

  static bool isLocalMessage(CoachMessage message) =>
      message.id.startsWith(localMessagePrefix);

  /// Opens the most recent conversation, or creates the first one when the
  /// user has none yet.
  Future<void> startSession({
    required String userId,
    required String newConversationTitle,
  }) async {
    await loadConversations(userId: userId);
    if (state.status != AiCoachStatus.success) return;

    if (state.conversations.isEmpty) {
      await createConversation(userId: userId, title: newConversationTitle);
      return;
    }

    await openConversation(
      userId: userId,
      conversation: state.conversations.first,
    );
  }

  Future<void> loadConversations({
    required String userId,
    bool includeArchived = false,
  }) async {
    emit(state.copyWith(status: AiCoachStatus.loading, clearError: true));

    try {
      final result = await getUserConversations(
        userId: userId,
        page: 1,
        pageSize: pageSize,
        includeArchived: includeArchived,
      );

      emit(
        state.copyWith(status: AiCoachStatus.success, conversations: result),
      );
    } catch (error) {
      emit(
        state.copyWith(
          status: AiCoachStatus.failure,
          errorMessage: error.toString(),
        ),
      );
    }
  }

  Future<CoachConversation?> createConversation({
    required String userId,
    required String title,
  }) async {
    try {
      final conversation = await createCoachConversation(
        userId: userId,
        title: title,
      );

      emit(
        state.copyWith(
          status: AiCoachStatus.success,
          conversations: [
            conversation,
            ...state.conversations.where((item) => item.id != conversation.id),
          ],
          currentConversation: conversation,
          messages: const [],
          hasMoreMessages: true,
          clearError: true,
          clearNutritionAdvice: true,
        ),
      );

      return conversation;
    } catch (error) {
      emit(
        state.copyWith(
          status: AiCoachStatus.failure,
          errorMessage: error.toString(),
        ),
      );
      return null;
    }
  }

  Future<void> openConversation({
    required String userId,
    required CoachConversation conversation,
  }) async {
    emit(
      state.copyWith(
        status: AiCoachStatus.loading,
        currentConversation: conversation,
        messages: const [],
        hasMoreMessages: true,
        clearError: true,
        clearNutritionAdvice: true,
      ),
    );

    await loadHistory(userId: userId, conversationId: conversation.id, page: 1);
  }

  Future<void> loadHistory({
    required String userId,
    required String conversationId,
    int page = 1,
  }) async {
    if (state.isLoadingMore) return;
    if (page > 1 && !state.hasMoreMessages) return;

    emit(
      state.copyWith(
        isLoadingMore: page > 1,
        status: page == 1 ? AiCoachStatus.loading : state.status,
        clearError: true,
      ),
    );

    try {
      final result = await getConversationHistory(
        userId: userId,
        conversationId: conversationId,
        page: page,
        pageSize: pageSize,
      );

      final combined = page == 1 ? result : [...result, ...state.messages];

      emit(
        state.copyWith(
          status: AiCoachStatus.success,
          messages: _sorted(combined),
          isLoadingMore: false,
          hasMoreMessages: result.length == pageSize,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          status: page == 1 ? AiCoachStatus.failure : state.status,
          isLoadingMore: false,
          errorMessage: error.toString(),
        ),
      );
    }
  }

  /// Loads the page of messages that precedes the ones already on screen.
  Future<void> loadEarlierMessages({required String userId}) async {
    final conversation = state.currentConversation;
    if (conversation == null) return;

    final loaded = state.messages.where((item) => !isLocalMessage(item));
    final nextPage = (loaded.length ~/ pageSize) + 1;

    await loadHistory(
      userId: userId,
      conversationId: conversation.id,
      page: nextPage,
    );
  }

  Future<void> sendMessage({
    required String userId,
    required String message,
  }) async {
    final conversation = state.currentConversation;
    final text = message.trim();

    if (conversation == null || text.isEmpty || state.isSending) {
      return;
    }

    // Show the user's own message immediately; the repository only returns
    // the assistant reply.
    final pending = CoachMessage(
      id: '$localMessagePrefix${DateTime.now().microsecondsSinceEpoch}',
      conversationId: conversation.id,
      userId: userId,
      role: CoachMessageRole.user,
      content: text,
      createdAt: DateTime.now(),
    );

    emit(
      state.copyWith(
        isSending: true,
        messages: [...state.messages, pending],
        clearError: true,
      ),
    );

    try {
      final response = await sendCoachMessage(
        userId: userId,
        conversationId: conversation.id,
        message: text,
      );

      if (state.currentConversation?.id != conversation.id) {
        emit(state.copyWith(isSending: false));
        return;
      }

      emit(
        state.copyWith(
          status: AiCoachStatus.success,
          messages: _sorted([...state.messages, response]),
          isSending: false,
        ),
      );

      await _reconcileLatest(
        userId: userId,
        conversationId: conversation.id,
      );
    } catch (error) {
      emit(
        state.copyWith(
          isSending: false,
          messages:
              state.messages.where((item) => item.id != pending.id).toList(),
          errorMessage: error.toString(),
        ),
      );
    }
  }

  /// Replaces the optimistic local message with the stored one. Failures are
  /// ignored: the reply was already delivered.
  Future<void> _reconcileLatest({
    required String userId,
    required String conversationId,
  }) async {
    try {
      final latest = await getConversationHistory(
        userId: userId,
        conversationId: conversationId,
        page: 1,
        pageSize: pageSize,
      );

      if (latest.isEmpty ||
          state.currentConversation?.id != conversationId ||
          state.isSending) {
        return;
      }

      final oldest = latest
          .map((item) => item.createdAt)
          .reduce((a, b) => a.isBefore(b) ? a : b);

      final older = state.messages.where(
        (item) => !isLocalMessage(item) && item.createdAt.isBefore(oldest),
      );

      emit(state.copyWith(messages: _sorted([...older, ...latest])));
    } catch (_) {
      // Keep what is already on screen.
    }
  }

  Future<void> deleteConversation({
    required String userId,
    required String conversationId,
  }) async {
    try {
      await deleteCoachConversation(
        userId: userId,
        conversationId: conversationId,
      );

      final isCurrent = state.currentConversation?.id == conversationId;

      emit(
        state.copyWith(
          status: AiCoachStatus.success,
          conversations: state.conversations
              .where((item) => item.id != conversationId)
              .toList(),
          messages: isCurrent ? const [] : state.messages,
          clearCurrentConversation: isCurrent,
          clearNutritionAdvice: isCurrent,
          clearError: true,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          status: AiCoachStatus.failure,
          errorMessage: error.toString(),
        ),
      );
    }
  }

  Future<void> loadNutritionAdvice({
    required String userId,
    required List<String> dietaryPreferences,
    required List<String> allergies,
    required List<String> referencedMealIds,
    required String? goal,
  }) async {
    if (state.isLoadingAdvice) return;
    emit(state.copyWith(isLoadingAdvice: true, clearError: true));

    try {
      final advice = await getNutritionAdvice(
        userId: userId,
        dietaryPreferences: dietaryPreferences,
        allergies: allergies,
        referencedMealIds: referencedMealIds,
        goal: goal,
      );

      emit(
        state.copyWith(
          status: AiCoachStatus.success,
          nutritionAdvice: advice,
          clearError: true,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          status: AiCoachStatus.failure,
          errorMessage: error.toString(),
        ),
      );
    }
  }

  void clearError() {
    emit(state.copyWith(clearError: true));
  }

  void resetConversation() {
    emit(
      state.copyWith(
        messages: const [],
        clearCurrentConversation: true,
        clearNutritionAdvice: true,
        clearError: true,
        hasMoreMessages: true,
      ),
    );
  }

  List<CoachMessage> _sorted(Iterable<CoachMessage> items) {
    final byId = <String, CoachMessage>{
      for (final item in items) item.id: item,
    };
    return byId.values.toList()
      ..sort((a, b) => a.createdAt.compareTo(b.createdAt));
  }
}
