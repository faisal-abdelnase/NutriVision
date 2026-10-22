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

final sl = GetIt.instance;

Future<void> registerAiCoachDependencies() async {
  // Remote dependencies
  if (!sl.isRegistered<FirebaseFirestore>()) {
    sl.registerLazySingleton<FirebaseFirestore>(
      () => FirebaseFirestore.instance,
    );
  }

  sl.registerLazySingleton<GenerativeModel>(
    () => FirebaseAI.googleAI().generativeModel(model: 'gemini-3.8-flash'),
  );

  sl.registerLazySingleton<AiCoachRemoteDataSource>(
    () => AiCoachRemoteDataSourceImpl(
      firestore: sl<FirebaseFirestore>(),
      model: sl<GenerativeModel>(),
    ),
  );

  // Local dependencies: boxes are opened in main() before runApp().
  sl.registerLazySingleton<AiCoachLocalDataSource>(
    () => AiCoachLocalDataSourceImpl(
      messagesBox: Hive.box('ai_coach_messages'),
      conversationsBox: Hive.box('ai_coach_conversations'),
      adviceBox: Hive.box('ai_coach_advice'),
    ),
  );

  // Repository
  sl.registerLazySingleton<AiCoachRepository>(
    () => AiCoachRepositoryImpl(
      remoteDataSource: sl<AiCoachRemoteDataSource>(),
      localDataSource: sl<AiCoachLocalDataSource>(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => SendCoachMessage(sl<AiCoachRepository>()));
  sl.registerLazySingleton(
    () => GetConversationHistory(sl<AiCoachRepository>()),
  );
  sl.registerLazySingleton(() => GetUserConversations(sl<AiCoachRepository>()));
  sl.registerLazySingleton(
    () => CreateCoachConversation(sl<AiCoachRepository>()),
  );
  sl.registerLazySingleton(
    () => DeleteCoachConversation(sl<AiCoachRepository>()),
  );
  sl.registerLazySingleton(
    () => GetPersonalizedNutritionAdvice(sl<AiCoachRepository>()),
  );

  // Cubit
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
