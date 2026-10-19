import '../../domain/entities/user_profile.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_remote_data_source.dart';
import '../datasources/profile_storage_data_source.dart';
import '../models/user_profile_model.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;
  final ProfileStorageDataSource storageDataSource;

  ProfileRepositoryImpl({
    required this.remoteDataSource,
    required this.storageDataSource,
  });

  @override
  Future<UserProfile?> getUserProfile({
    required String userId,
  }) {
    return remoteDataSource.fetchUserProfile(
      userId: userId,
    );
  }

  @override
  Future<UserProfile> updateUserProfile({
    required UserProfile profile,
  }) {
    return remoteDataSource.updateUserProfile(
      profile: UserProfileModel.fromEntity(profile),
    );
  }

  @override
  Future<String> uploadProfilePhoto({
    required String userId,
    required String imagePath,
  }) async {
    final oldProfile = await getUserProfile(userId: userId);

    final imageUrl = await storageDataSource.uploadProfileImage(
      userId: userId,
      imagePath: imagePath,
    );

    try {
      if (oldProfile != null) {
        await updateUserProfile(
          profile: UserProfileModel.fromEntity(oldProfile)
              .copyWithPhoto(imageUrl),
        );
      }

      return imageUrl;
    } catch (_) {
      // Avoid leaving an unreferenced uploaded image.
      await storageDataSource.deleteProfileImage(
        userId: userId,
        imageUrl: imageUrl,
      );
      rethrow;
    }
  }

  @override
  Future<void> deleteProfilePhoto({
    required String userId,
  }) async {
    final profile = await getUserProfile(userId: userId);

    if (profile == null || profile.profilePhotoUrl == null) {
      return;
    }

    await updateUserProfile(
      profile: UserProfileModel.fromEntity(profile)
          .copyWithPhoto(null),
    );

    await storageDataSource.deleteProfileImage(
      userId: userId,
      imageUrl: profile.profilePhotoUrl!,
    );
  }

  @override
  Future<void> deleteUserAccount({
    required String userId,
    required String reauthenticationToken,
  }) async {
    final profile = await getUserProfile(userId: userId);

    if (profile?.profilePhotoUrl case final String photoUrl
        when photoUrl.isNotEmpty) {
      await storageDataSource.deleteProfileImage(
        userId: userId,
        imageUrl: photoUrl,
      );
    }

    await remoteDataSource.deleteUserAccount(
      userId: userId,
      reauthenticationToken: reauthenticationToken,
    );
  }
}