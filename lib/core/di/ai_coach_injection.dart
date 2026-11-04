
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_ai/firebase_ai.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_ce/hive.dart';

import '../../features/ai_coach/data/datasources/ai_coach_local_data_source.dart';
import '../../features/ai_coach/data/datasources/ai_coach_local_data_source_impl.dart';
import '../../features/ai_coach/data/datasources/ai_coach_remote_data_source.dart';
import '../../features/ai_coach/data/datasources/ai_coach_remote_data_source_impl.dart';
import '../../features/ai_coach/data/repositories/ai_coach_repository_impl.dart';
import '../../features/ai_coach/domain/repositories/ai_coach_repository.dart';
import '../../features/ai_coach/domain/usecases/create_coach_conversation.dart';
import '../../features/ai_coach/domain/usecases/delete_coach_conversation.dart';
import '../../features/ai_coach/domain/usecases/get_conversation_history.dart';
import '../../features/ai_coach/domain/usecases/get_personalized_nutrition_advice.dart';
import '../../features/ai_coach/domain/usecases/get_user_conversations.dart';
import '../../features/ai_coach/domain/usecases/send_coach_message.dart';
import '../../features/ai_coach/presentation/cubit/ai_coach_cubit.dart';
import '../logging/ai_coach_diagnostics.dart';

final sl = GetIt.instance;

const aiCoachModelName = 'gemini-3.5-flash-lite';

Future<void> registerAiCoachDependencies() async {
  // --------------------------------------------------
  // Firestore
  // --------------------------------------------------

  if (!sl.isRegistered<FirebaseFirestore>()) {
    sl.registerLazySingleton<FirebaseFirestore>(
      () => FirebaseFirestore.instance,
    );
  }

  // --------------------------------------------------
  // Firebase AI Logic
  // --------------------------------------------------

  if (!sl.isRegistered<FirebaseAI>()) {
    AiCoachDiagnostics.info(
      'Initializing Firebase AI Logic with Google AI backend.',
    );

    final firebaseAI = await FirebaseAI.googleAI(
      useLimitedUseAppCheckTokens: true,
    );

    sl.registerSingleton<FirebaseAI>(firebaseAI);

    AiCoachDiagnostics.info(
      'Firebase AI Logic initialized with limited-use App Check tokens.',
    );
  }

  // --------------------------------------------------
  // Generative Model
  // --------------------------------------------------

  if (!sl.isRegistered<GenerativeModel>()) {
    sl.registerLazySingleton<GenerativeModel>(
      () {
        AiCoachDiagnostics.info(
          'Configuring AI Coach model: $aiCoachModelName.',
        );

        return sl<FirebaseAI>().generativeModel(
          model: aiCoachModelName,
        );
      },
    );
  }

  // --------------------------------------------------
  // Remote Data Source
  // --------------------------------------------------

  if (!sl.isRegistered<AiCoachRemoteDataSource>()) {
    sl.registerLazySingleton<AiCoachRemoteDataSource>(
      () => AiCoachRemoteDataSourceImpl(
        firestore: sl<FirebaseFirestore>(),
        model: sl<GenerativeModel>(),
      ),
    );
  }

  // --------------------------------------------------
  // Local Data Source
  // Hive boxes must be opened in main() before this
  // dependency is requested.
  // --------------------------------------------------

  if (!sl.isRegistered<AiCoachLocalDataSource>()) {
    sl.registerLazySingleton<AiCoachLocalDataSource>(
      () => AiCoachLocalDataSourceImpl(
        messagesBox: Hive.box('ai_coach_messages'),
        conversationsBox: Hive.box('ai_coach_conversations'),
        adviceBox: Hive.box('ai_coach_advice'),
      ),
    );
  }

  // --------------------------------------------------
  // Repository
  // --------------------------------------------------

  if (!sl.isRegistered<AiCoachRepository>()) {
    sl.registerLazySingleton<AiCoachRepository>(
      () => AiCoachRepositoryImpl(
        remoteDataSource: sl<AiCoachRemoteDataSource>(),
        localDataSource: sl<AiCoachLocalDataSource>(),
      ),
    );
  }

  // --------------------------------------------------
  // Use Cases
  // --------------------------------------------------

  if (!sl.isRegistered<SendCoachMessage>()) {
    sl.registerLazySingleton(
      () => SendCoachMessage(sl<AiCoachRepository>()),
    );
  }

  if (!sl.isRegistered<GetConversationHistory>()) {
    sl.registerLazySingleton(
      () => GetConversationHistory(sl<AiCoachRepository>()),
    );
  }

  if (!sl.isRegistered<GetUserConversations>()) {
    sl.registerLazySingleton(
      () => GetUserConversations(sl<AiCoachRepository>()),
    );
  }

  if (!sl.isRegistered<CreateCoachConversation>()) {
    sl.registerLazySingleton(
      () => CreateCoachConversation(sl<AiCoachRepository>()),
    );
  }

  if (!sl.isRegistered<DeleteCoachConversation>()) {
    sl.registerLazySingleton(
      () => DeleteCoachConversation(sl<AiCoachRepository>()),
    );
  }

  if (!sl.isRegistered<GetPersonalizedNutritionAdvice>()) {
    sl.registerLazySingleton(
      () => GetPersonalizedNutritionAdvice(sl<AiCoachRepository>()),
    );
  }

  // --------------------------------------------------
  // Cubit
  // --------------------------------------------------

  if (!sl.isRegistered<AiCoachCubit>()) {
    sl.registerFactory(
      () => AiCoachCubit(
        sendCoachMessage: sl<SendCoachMessage>(),
        getConversationHistory: sl<GetConversationHistory>(),
        getUserConversations: sl<GetUserConversations>(),
        createCoachConversation: sl<CreateCoachConversation>(),
        deleteCoachConversation: sl<DeleteCoachConversation>(),
        getNutritionAdvice: sl<GetPersonalizedNutritionAdvice>(),
      ),
    );
  }

  AiCoachDiagnostics.info(
    'AI Coach dependencies registered successfully.',
  );
}
