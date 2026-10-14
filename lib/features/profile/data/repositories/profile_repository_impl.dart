

import '../../domain/entities/user_profile.dart';
import '../../domain/repositories/profile_repository.dart';

import '../datasources/profile_remote_data_source.dart';
import '../datasources/profile_storage_data_source.dart';

abstract class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;
  final ProfileStorageDataSource storageDataSource;

  ProfileRepositoryImpl({
    required this.remoteDataSource,
    required this.storageDataSource,
  });

  @override
  Future<UserProfile?> getUserProfile({
    required String userId,
  });

  @override
  Future<UserProfile> updateUserProfile({
    required UserProfile profile,
  });

  @override
  Future<String> uploadProfilePhoto({
    required String userId,
    required String imagePath,
  });

  @override
  Future<void> deleteProfilePhoto({
    required String userId,
  });

  @override
  Future<void> deleteUserAccount({
    required String userId,
    required String reauthenticationToken,
  });
}