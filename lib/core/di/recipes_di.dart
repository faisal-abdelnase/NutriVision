import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_ai/firebase_ai.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../../features/recipes/data/datasources/grocery_list_local_data_source.dart';
import '../../features/recipes/data/datasources/grocery_list_local_data_source_impl.dart';
import '../../features/recipes/data/datasources/recipe_generator_data_source.dart';
import '../../features/recipes/data/datasources/recipes_remote_data_source.dart';
import '../../features/recipes/data/datasources/recipes_remote_data_source_impl.dart';
import '../../features/recipes/data/repositories/recipes_repository_impl.dart';
import '../../features/recipes/domain/repositories/recipes_repository.dart';
import '../../features/recipes/presentation/cubit/grocery_list_cubit.dart';
import '../../features/recipes/presentation/cubit/recipes_cubit.dart';

final sl = GetIt.instance;

Future<void> registerRecipesDependencies() async {
  if (!sl.isRegistered<FirebaseFirestore>()) {
    sl.registerLazySingleton<FirebaseFirestore>(
      () => FirebaseFirestore.instance,
    );
  }

  if (!sl.isRegistered<SharedPreferences>()) {
    throw StateError('Register SharedPreferences before Recipes dependencies.');
  }

  if (!sl.isRegistered<Uuid>()) {
    sl.registerLazySingleton<Uuid>(() => const Uuid());
  }

  sl.registerLazySingleton<RecipeGeneratorDataSource>(
    () => RecipeGeneratorDataSourceImpl(
      model: sl<GenerativeModel>(),
      firestore: sl<FirebaseFirestore>(),
      auth: sl<FirebaseAuth>(),
    ),
  );

  sl.registerLazySingleton<RecipesRemoteDataSource>(
    () => RecipesRemoteDataSourceImpl(
      firestore: sl<FirebaseFirestore>(),
      recipeGenerator: sl<RecipeGeneratorDataSource>(),
    ),
  );

  sl.registerLazySingleton<GroceryListLocalDataSource>(
    () => GroceryListLocalDataSourceImpl(sl<SharedPreferences>()),
  );

  sl.registerLazySingleton<RecipesRepository>(
    () => RecipesRepositoryImpl(
      remoteDataSource: sl<RecipesRemoteDataSource>(),
      groceryListLocalDataSource: sl<GroceryListLocalDataSource>(),
    ),
  );

  sl.registerFactory<RecipesCubit>(() => RecipesCubit(sl<RecipesRepository>()));

  sl.registerFactory<GroceryListCubit>(
    () => GroceryListCubit(sl<RecipesRepository>()),
  );
}
