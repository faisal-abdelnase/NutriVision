import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';

import '../nutrition_context/nutrition_context_provider.dart';

Future<void> registerNutritionContextDependencies() async {
  final sl = GetIt.instance;
  if (!sl.isRegistered<FirebaseFirestore>()) {
    sl.registerLazySingleton(() => FirebaseFirestore.instance);
  }
  if (!sl.isRegistered<FirebaseAuth>()) {
    sl.registerLazySingleton(() => FirebaseAuth.instance);
  }
  if (!sl.isRegistered<NutritionContextProvider>()) {
    sl.registerLazySingleton(
      () => NutritionContextProvider(
        firestore: sl<FirebaseFirestore>(),
        auth: sl<FirebaseAuth>(),
      ),
    );
  }
}
