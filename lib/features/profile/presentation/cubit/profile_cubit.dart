import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/user_profile.dart';
import '../../domain/usecases/get_user_profile.dart';
import '../../domain/usecases/update_user_profile.dart';
import '../../domain/usecases/upload_profile_photo.dart';
import '../../domain/usecases/delete_profile_photo.dart';
import '../../domain/usecases/delete_user_account.dart';
import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final GetUserProfile getUserProfile;
  final UpdateUserProfile updateUserProfile;
  final UploadProfilePhoto uploadProfilePhoto;
  final DeleteProfilePhoto deleteProfilePhoto;
  final DeleteUserAccount deleteUserAccount;

  ProfileCubit({
    required this.getUserProfile,
    required this.updateUserProfile,
    required this.uploadProfilePhoto,
    required this.deleteProfilePhoto,
    required this.deleteUserAccount,
  }) : super(const ProfileState());

  Future<void> loadProfile(String userId) async {
    emit(state.copyWith(status: ProfileStatus.loading, clearError: true));

    try {
      final profile = await getUserProfile(userId: userId);

      emit(
        state.copyWith(
          status: ProfileStatus.success,
          profile: profile,
          clearProfile: profile == null,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: ProfileStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> updateProfile(UserProfile profile) async {
    emit(state.copyWith(status: ProfileStatus.updating, clearError: true));

    try {
      final updated = await updateUserProfile(profile: profile);

      emit(state.copyWith(status: ProfileStatus.success, profile: updated));
    } catch (e) {
      emit(
        state.copyWith(
          status: ProfileStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> uploadPhoto({
    required String userId,
    required String imagePath,
  }) async {
    emit(
      state.copyWith(status: ProfileStatus.uploadingPhoto, clearError: true),
    );

    try {
      await uploadProfilePhoto(userId: userId, imagePath: imagePath);

      final profile = await getUserProfile(userId: userId);

      emit(
        state.copyWith(
          status: ProfileStatus.success,
          profile: profile,
          clearProfile: profile == null,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: ProfileStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> removePhoto(String userId) async {
    emit(state.copyWith(status: ProfileStatus.updating, clearError: true));

    try {
      await deleteProfilePhoto(userId: userId);

      final profile = await getUserProfile(userId: userId);

      emit(
        state.copyWith(
          status: ProfileStatus.success,
          profile: profile,
          clearProfile: profile == null,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: ProfileStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> deleteAccount({
    required String userId,
    required String reauthenticationToken,
  }) async {
    emit(state.copyWith(status: ProfileStatus.deleting, clearError: true));

    try {
      await deleteUserAccount(
        userId: userId,
        reauthenticationToken: reauthenticationToken,
      );

      emit(state.copyWith(status: ProfileStatus.success, clearProfile: true));
    } catch (e) {
      emit(
        state.copyWith(
          status: ProfileStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
