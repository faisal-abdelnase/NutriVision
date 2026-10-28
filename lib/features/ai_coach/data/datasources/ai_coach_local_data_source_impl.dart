import 'package:hive_ce/hive.dart';

import '../models/coach_conversation_model.dart';
import '../models/coach_message_model.dart';
import '../models/nutrition_advice_model.dart';
import 'ai_coach_local_data_source.dart';

class AiCoachLocalDataSourceImpl implements AiCoachLocalDataSource {
  final Box messagesBox;
  final Box conversationsBox;
  final Box adviceBox;

  AiCoachLocalDataSourceImpl({
    required this.messagesBox,
    required this.conversationsBox,
    required this.adviceBox,
  });

  String _messagesKey(String id) => 'conversation_$id';
  String _conversationsKey(String id) => 'user_$id';
  String _adviceKey(String id) => 'user_$id';

  @override
  Future<void> cacheConversationMessages({
    required String conversationId,
    required List<CoachMessageModel> messages,
  }) async {
    await messagesBox.put(
      _messagesKey(conversationId),
      messages.map((item) => item.toJson()).toList(),
    );
  }

  @override
  Future<List<CoachMessageModel>> getCachedConversationMessages({
    required String conversationId,
  }) async {
    final raw = messagesBox.get(_messagesKey(conversationId));
    if (raw is! List) return [];

    return raw
        .whereType<Map>()
        .map(
          (item) => CoachMessageModel.fromJson(Map<String, dynamic>.from(item)),
        )
        .toList();
  }

  @override
  Future<void> cacheUserConversations({
    required String userId,
    required List<CoachConversationModel> conversations,
  }) async {
    await conversationsBox.put(
      _conversationsKey(userId),
      conversations.map((item) => item.toJson()).toList(),
    );
  }

  @override
  Future<List<CoachConversationModel>> getCachedUserConversations({
    required String userId,
  }) async {
    final raw = conversationsBox.get(_conversationsKey(userId));
    if (raw is! List) return [];

    return raw
        .whereType<Map>()
        .map(
          (item) =>
              CoachConversationModel.fromJson(Map<String, dynamic>.from(item)),
        )
        .toList();
  }

  @override
  Future<void> cacheNutritionAdvice({
    required NutritionAdviceModel advice,
  }) async {
    await adviceBox.put(_adviceKey(advice.userId), advice.toJson());
  }

  @override
  Future<NutritionAdviceModel?> getCachedNutritionAdvice({
    required String userId,
  }) async {
    final raw = adviceBox.get(_adviceKey(userId));
    if (raw is! Map) return null;

    final advice = NutritionAdviceModel.fromJson(
      Map<String, dynamic>.from(raw),
    );

    if (advice.expiresAt != null &&
        advice.expiresAt!.isBefore(DateTime.now())) {
      await adviceBox.delete(_adviceKey(userId));
      return null;
    }

    return advice;
  }

  @override
  Future<void> clearConversationCache({required String conversationId}) async {
    await messagesBox.delete(_messagesKey(conversationId));
  }

  @override
  Future<void> clearUserCoachCache({required String userId}) async {
    await conversationsBox.delete(_conversationsKey(userId));
    await adviceBox.delete(_adviceKey(userId));
  }
}
