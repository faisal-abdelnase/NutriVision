import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_ai/firebase_ai.dart';

import '../../domain/entities/coach_message.dart';
import '../models/coach_conversation_model.dart';
import '../models/coach_message_model.dart';
import '../models/nutrition_advice_model.dart';
import 'ai_coach_remote_data_source.dart';
import 'dart:convert';

class AiCoachRemoteDataSourceImpl implements AiCoachRemoteDataSource {
  final FirebaseFirestore firestore;
  final GenerativeModel model;

  AiCoachRemoteDataSourceImpl({required this.firestore, required this.model});

  CollectionReference<Map<String, dynamic>> _conversations(String userId) =>
      firestore
          .collection('users')
          .doc(userId)
          .collection('aiCoachConversations');

  CollectionReference<Map<String, dynamic>> _messages(
    String userId,
    String conversationId,
  ) => _conversations(userId).doc(conversationId).collection('messages');

  @override
  Future<CoachConversationModel> createConversation({
    required String userId,
    required String title,
  }) async {
    final now = Timestamp.now();
    final ref = _conversations(userId).doc();

    final conversation = CoachConversationModel(
      id: ref.id,
      userId: userId,
      title: title.trim().isEmpty ? 'New conversation' : title.trim(),
      createdAt: now.toDate(),
      updatedAt: now.toDate(),
    );

    await ref.set(conversation.toFirestore());
    return conversation;
  }

  @override
  Future<CoachMessageModel> sendMessage({
    required String userId,
    required String conversationId,
    required String message,
    required List<CoachMessageModel> conversationContext,
  }) async {
    final conversationRef = _conversations(userId).doc(conversationId);
    final conversationSnapshot = await conversationRef.get();

    if (!conversationSnapshot.exists) {
      throw StateError('Conversation not found.');
    }

    final text = message.trim();
    if (text.isEmpty) {
      throw ArgumentError('Message cannot be empty.');
    }

    final messagesRef = _messages(userId, conversationId);
    final userMessageRef = messagesRef.doc();

    final userMessage = CoachMessageModel(
      id: userMessageRef.id,
      conversationId: conversationId,
      userId: userId,
      role: CoachMessageRole.user,
      content: text,
      createdAt: DateTime.now(),
    );

    await userMessageRef.set(userMessage.toFirestore());

    final context =
        conversationContext
            .where((item) => item.role != CoachMessageRole.system)
            .toList()
          ..sort((a, b) => a.createdAt.compareTo(b.createdAt));

    final history = context
        .map(
          (item) =>
              '${item.role == CoachMessageRole.user ? "User" : "Assistant"}: '
              '${item.content}',
        )
        .join('\n');

    const systemPrompt = '''
You are NutriVision AI Coach, a helpful nutrition and healthy-lifestyle assistant.
Reply in the same language used by the user, including Arabic when appropriate.
Give practical, evidence-informed general nutrition guidance.
Never invent a user's medical history or nutritional measurements.
Do not diagnose diseases or recommend dangerous diets.
Mention relevant allergies and dietary restrictions when provided.
For medical symptoms or urgent concerns, advise consulting a qualified professional.
You are not a substitute for a registered dietitian or physician.
''';

    final prompt =
        '''
$systemPrompt

Previous conversation:
${history.isEmpty ? 'No previous messages.' : history}

New user message:
$text

Provide a clear, friendly, personalized response.
''';

    final response = await model.generateContent([Content.text(prompt)]);

    final answer = response.text?.trim();
    if (answer == null || answer.isEmpty) {
      throw StateError('Gemini returned an empty response.');
    }

    final assistantRef = messagesRef.doc();

    final assistantMessage = CoachMessageModel(
      id: assistantRef.id,
      conversationId: conversationId,
      userId: userId,
      role: CoachMessageRole.assistant,
      content: answer,
      createdAt: DateTime.now(),
      modelName: 'gemini-2.5-flash',
    );

    final batch = firestore.batch();
    batch.set(assistantRef, assistantMessage.toFirestore());
    batch.update(conversationRef, {
      'lastMessagePreview': answer.length > 120
          ? '${answer.substring(0, 120)}...'
          : answer,
      'lastMessageAt': Timestamp.now(),
      'updatedAt': Timestamp.now(),
    });
    await batch.commit();

    return assistantMessage;
  }

  @override
  Future<List<CoachMessageModel>> fetchConversationHistory({
    required String userId,
    required String conversationId,
    required int page,
    required int pageSize,
  }) async {
    if (page < 1 || pageSize < 1) {
      throw ArgumentError('Page and pageSize must be positive.');
    }

    Query<Map<String, dynamic>> query = _messages(
      userId,
      conversationId,
    ).orderBy('createdAt', descending: true);

    final precedingCount = (page - 1) * pageSize;
    if (precedingCount > 0) {
      final precedingMessages = await query.limit(precedingCount).get();
      if (precedingMessages.docs.length < precedingCount) {
        return [];
      }
      query = query.startAfterDocument(precedingMessages.docs.last);
    }

    final snapshot = await query.limit(pageSize).get();

    return snapshot.docs
        .map(CoachMessageModel.fromFirestore)
        .toList()
        .reversed
        .toList();
  }

  @override
  Future<List<CoachConversationModel>> fetchUserConversations({
    required String userId,
    required int page,
    required int pageSize,
    required bool includeArchived,
  }) async {
    if (page < 1 || pageSize < 1) {
      throw ArgumentError('Page and pageSize must be positive.');
    }

    Query<Map<String, dynamic>> query = _conversations(userId);

    if (!includeArchived) {
      query = query.where('isArchived', isEqualTo: false);
    }

    query = query.orderBy('updatedAt', descending: true);

    if (page > 1) {
      final previousPage = await query.limit((page - 1) * pageSize).get();
      if (previousPage.docs.length < (page - 1) * pageSize) {
        return [];
      }
      query = query.startAfterDocument(previousPage.docs.last);
    }

    final snapshot = await query.limit(pageSize).get();

    return snapshot.docs.map(CoachConversationModel.fromFirestore).toList();
  }

  @override
  Future<void> deleteConversation({
    required String userId,
    required String conversationId,
  }) async {
    final conversationRef = _conversations(userId).doc(conversationId);

    // Firestore لا يحذف subcollections تلقائيًا.
    // حذف رسائل المحادثة على دفعات لتفادي تجاوز حد الـ batch.
    while (true) {
      final snapshot = await conversationRef
          .collection('messages')
          .limit(400)
          .get();

      if (snapshot.docs.isEmpty) break;

      final batch = firestore.batch();
      for (final doc in snapshot.docs) {
        batch.delete(doc.reference);
      }
      await batch.commit();
    }

    await conversationRef.delete();
  }

  @override
  Future<NutritionAdviceModel> fetchPersonalizedNutritionAdvice({
    required String userId,
    required List<String> dietaryPreferences,
    required List<String> allergies,
    required List<String> referencedMealIds,
    required String? goal,
  }) async {
    final prompt =
        '''
You are NutriVision's nutrition assistant.
Generate general nutrition guidance, not a medical diagnosis.

User goal: ${goal ?? 'General healthy eating'}
Dietary preferences: ${dietaryPreferences.join(', ')}
Allergies: ${allergies.join(', ')}
Referenced meal IDs: ${referencedMealIds.join(', ')}

Return ONLY valid JSON with these keys:
title (string), content (string), category (string),
recommendations (array of strings), warnings (array of strings).

Use the user's language where possible.
Do not claim to have inspected meals based on IDs alone.
Do not invent personal health data.
Treat listed allergies seriously and advise professional care for medical concerns.
''';

    final response = await model.generateContent([Content.text(prompt)]);

    final text = response.text?.trim();
    if (text == null || text.isEmpty) {
      throw StateError('Gemini returned an empty nutrition response.');
    }

    // Implemented in the next section with strict JSON parsing.
    return _parseAdvice(
      userId: userId,
      dietaryPreferences: dietaryPreferences,
      allergies: allergies,
      referencedMealIds: referencedMealIds,
      goal: goal,
      generatedText: text,
    );
  }

  Future<NutritionAdviceModel> _parseAdvice({
    required String userId,
    required List<String> dietaryPreferences,
    required List<String> allergies,
    required List<String> referencedMealIds,
    required String? goal,
    required String generatedText,
  }) async {
    final cleaned = generatedText
        .replaceAll(RegExp(r'^```(?:json)?\s*'), '')
        .replaceAll(RegExp(r'\s*```$'), '')
        .trim();

    final decoded = jsonDecode(cleaned);

    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('Gemini response must be a JSON object.');
    }

    List<String> readStringList(String key) {
      final value = decoded[key];
      if (value is! List) return const [];

      return value.whereType<String>().toList();
    }

    final adviceRef = _conversations(
      userId,
    ).doc('_nutrition_advice').collection('items').doc();

    final now = Timestamp.now();

    final advice = NutritionAdviceModel(
      id: adviceRef.id,
      userId: userId,
      title: decoded['title'] is String
          ? decoded['title'] as String
          : 'Nutrition advice',
      content: decoded['content'] is String
          ? decoded['content'] as String
          : 'No advice content returned.',
      category: decoded['category'] is String
          ? decoded['category'] as String
          : 'general',
      recommendations: readStringList('recommendations'),
      warnings: [
        ...readStringList('warnings'),
        if (allergies.isNotEmpty)
          'Verify all ingredients against your reported allergies.',
      ],
      referencedMealIds: referencedMealIds,
      generatedAt: now.toDate(),
      expiresAt: now.toDate().add(const Duration(days: 7)),
    );

    await adviceRef.set(advice.toFirestore());
    return advice;
  }
}
