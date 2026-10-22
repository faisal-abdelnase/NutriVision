
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

  Future<void> loadConversations({
    required String userId,
    bool includeArchived = false,
  }) async {
    emit(state.copyWith(
      status: AiCoachStatus.loading,
      clearError: true,
    ));

    try {
      final result = await getUserConversations(
        userId: userId,
        page: 1,
        pageSize: pageSize,
        includeArchived: includeArchived,
      );

      emit(state.copyWith(
        status: AiCoachStatus.success,
        conversations: result,
      ));
    } catch (error) {
      emit(state.copyWith(
        status: AiCoachStatus.failure,
        errorMessage: error.toString(),
      ));
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

      emit(state.copyWith(
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
      ));

      return conversation;
    } catch (error) {
      emit(state.copyWith(
        status: AiCoachStatus.failure,
        errorMessage: error.toString(),
      ));
      return null;
    }
  }

  Future<void> openConversation({
    required String userId,
    required CoachConversation conversation,
  }) async {
    emit(state.copyWith(
      status: AiCoachStatus.loading,
      currentConversation: conversation,
      messages: const [],
      hasMoreMessages: true,
      clearError: true,
      clearNutritionAdvice: true,
    ));

    await loadHistory(
      userId: userId,
      conversationId: conversation.id,
      page: 1,
    );
  }

  Future<void> loadHistory({
    required String userId,
    required String conversationId,
    int page = 1,
  }) async {
    if (state.isLoadingMore) return;
    if (page > 1 && !state.hasMoreMessages) return;

    emit(state.copyWith(
      isLoadingMore: page > 1,
      status: page == 1 ? AiCoachStatus.loading : state.status,
      clearError: true,
    ));

    try {
      final result = await getConversationHistory(
        userId: userId,
        conversationId: conversationId,
        page: page,
        pageSize: pageSize,
      );

      final combined = page == 1
          ? result
          : [...result, ...state.messages];

      final unique = <String, CoachMessage>{
        for (final item in combined) item.id: item,
      }.values.toList()
        ..sort((a, b) => a.createdAt.compareTo(b.createdAt));

      emit(state.copyWith(
        status: AiCoachStatus.success,
        messages: unique,
        isLoadingMore: false,
        hasMoreMessages: result.length == pageSize,
      ));
    } catch (error) {
      emit(state.copyWith(
        status: page == 1 ? AiCoachStatus.failure : state.status,
        isLoadingMore: false,
        errorMessage: error.toString(),
      ));
    }
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

    emit(state.copyWith(
      isSending: true,
      clearError: true,
    ));

    try {
      final response = await sendCoachMessage(
        userId: userId,
        conversationId: conversation.id,
        message: text,
      );

      final updated = <String, CoachMessage>{
        for (final item in state.messages) item.id: item,
        response.id: response,
      }.values.toList()
        ..sort((a, b) => a.createdAt.compareTo(b.createdAt));

      emit(state.copyWith(
        status: AiCoachStatus.success,
        messages: updated,
        isSending: false,
      ));
    } catch (error) {
      emit(state.copyWith(
        isSending: false,
        errorMessage: error.toString(),
      ));
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

      final isCurrent =
          state.currentConversation?.id == conversationId;

      emit(state.copyWith(
        status: AiCoachStatus.success,
        conversations: state.conversations
            .where((item) => item.id != conversationId)
            .toList(),
        messages: isCurrent ? const [] : state.messages,
        clearCurrentConversation: isCurrent,
        clearNutritionAdvice: isCurrent,
        clearError: true,
      ));
    } catch (error) {
      emit(state.copyWith(
        status: AiCoachStatus.failure,
        errorMessage: error.toString(),
      ));
    }
  }

  Future<void> loadNutritionAdvice({
    required String userId,
    required List<String> dietaryPreferences,
    required List<String> allergies,
    required List<String> referencedMealIds,
    required String? goal,
  }) async {
    try {
      final advice = await getNutritionAdvice(
        userId: userId,
        dietaryPreferences: dietaryPreferences,
        allergies: allergies,
        referencedMealIds: referencedMealIds,
        goal: goal,
      );

      emit(state.copyWith(
        status: AiCoachStatus.success,
        nutritionAdvice: advice,
        clearError: true,
      ));
    } catch (error) {
      emit(state.copyWith(
        status: AiCoachStatus.failure,
        errorMessage: error.toString(),
      ));
    }
  }

  void clearError() {
    emit(state.copyWith(clearError: true));
  }

  void resetConversation() {
    emit(state.copyWith(
      messages: const [],
      clearCurrentConversation: true,
      clearNutritionAdvice: true,
      clearError: true,
      hasMoreMessages: true,
    ));
  }
}
