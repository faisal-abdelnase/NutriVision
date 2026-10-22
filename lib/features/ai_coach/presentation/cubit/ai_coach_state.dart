
import '../../domain/entities/coach_conversation.dart';
import '../../domain/entities/coach_message.dart';
import '../../domain/entities/nutrition_advice.dart';

enum AiCoachStatus {
  initial,
  loading,
  success,
  failure,
}

class AiCoachState {
  final AiCoachStatus status;
  final List<CoachConversation> conversations;
  final List<CoachMessage> messages;
  final CoachConversation? currentConversation;
  final NutritionAdvice? nutritionAdvice;
  final bool isSending;
  final bool isLoadingMore;
  final bool hasMoreMessages;
  final String? errorMessage;

  const AiCoachState({
    this.status = AiCoachStatus.initial,
    this.conversations = const [],
    this.messages = const [],
    this.currentConversation,
    this.nutritionAdvice,
    this.isSending = false,
    this.isLoadingMore = false,
    this.hasMoreMessages = true,
    this.errorMessage,
  });

  AiCoachState copyWith({
    AiCoachStatus? status,
    List<CoachConversation>? conversations,
    List<CoachMessage>? messages,
    CoachConversation? currentConversation,
    NutritionAdvice? nutritionAdvice,
    bool? isSending,
    bool? isLoadingMore,
    bool? hasMoreMessages,
    String? errorMessage,
    bool clearCurrentConversation = false,
    bool clearNutritionAdvice = false,
    bool clearError = false,
  }) {
    return AiCoachState(
      status: status ?? this.status,
      conversations: conversations ?? this.conversations,
      messages: messages ?? this.messages,
      currentConversation: clearCurrentConversation
          ? null
          : currentConversation ?? this.currentConversation,
      nutritionAdvice: clearNutritionAdvice
          ? null
          : nutritionAdvice ?? this.nutritionAdvice,
      isSending: isSending ?? this.isSending,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasMoreMessages: hasMoreMessages ?? this.hasMoreMessages,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }
}
