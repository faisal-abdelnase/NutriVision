import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_it/get_it.dart';

import '../../features/profile/data/datasources/profile_remote_data_source.dart';
import '../../features/profile/data/datasources/profile_remote_data_source_impl.dart';
import '../../features/profile/data/datasources/profile_storage_data_source.dart';
import '../../features/profile/data/datasources/profile_storage_data_source_impl.dart';
import '../../features/profile/data/repositories/profile_repository_impl.dart';
import '../../features/profile/domain/repositories/profile_repository.dart';
import '../../features/profile/domain/usecases/get_user_profile.dart';
import '../../features/profile/domain/usecases/update_user_profile.dart';
import '../../features/profile/domain/usecases/upload_profile_photo.dart';
import '../../features/profile/domain/usecases/delete_profile_photo.dart';
import '../../features/profile/domain/usecases/delete_user_account.dart';
import '../../features/profile/presentation/cubit/profile_cubit.dart';

final sl = GetIt.instance;

void registerProfileDependencies() {
  sl.registerLazySingleton<ProfileRemoteDataSource>(
    () => ProfileRemoteDataSourceImpl(
      firestore: FirebaseFirestore.instance,
      auth: FirebaseAuth.instance,
    ),
  );

  sl.registerLazySingleton<ProfileStorageDataSource>(
    () => ProfileStorageDataSourceImpl(
      storage: FirebaseStorage.instance,
    ),
  );

  sl.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(
      remoteDataSource: sl(),
      storageDataSource: sl(),
    ),
  );

  sl.registerLazySingleton(() => GetUserProfile(sl()));
  sl.registerLazySingleton(() => UpdateUserProfile(sl()));
  sl.registerLazySingleton(() => UploadProfilePhoto(sl()));
  sl.registerLazySingleton(() => DeleteProfilePhoto(sl()));
  sl.registerLazySingleton(() => DeleteUserAccount(sl()));

  sl.registerFactory(
    () => ProfileCubit(
      getUserProfile: sl(),
      updateUserProfile: sl(),
      uploadProfilePhoto: sl(),
      deleteProfilePhoto: sl(),
      deleteUserAccount: sl(),
    ),
  );
}