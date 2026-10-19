import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/user_profile_model.dart';
import 'profile_remote_data_source.dart';

class ProfileRemoteDataSourceImpl
    implements ProfileRemoteDataSource {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  ProfileRemoteDataSourceImpl({
    required this.firestore,
    required this.auth,
  });

  CollectionReference<Map<String, dynamic>>
      get _profiles => firestore.collection('users');

  @override
  Future<UserProfileModel?> fetchUserProfile({
    required String userId,
  }) async {
    final snapshot = await _profiles.doc(userId).get();

    if (!snapshot.exists || snapshot.data() == null) {
      return null;
    }

    return UserProfileModel.fromJson(snapshot.data()!);
  }

  @override
  Future<UserProfileModel> updateUserProfile({
    required UserProfileModel profile,
  }) async {
    final updatedProfile = UserProfileModel(
      userId: profile.userId,
      fullName: profile.fullName,
      email: profile.email,
      phoneNumber: profile.phoneNumber,
      profilePhotoUrl: profile.profilePhotoUrl,
      bio: profile.bio,
      dateOfBirth: profile.dateOfBirth,
      gender: profile.gender,
      preferredLanguage: profile.preferredLanguage,
      preferredTheme: profile.preferredTheme,
      notificationsEnabled: profile.notificationsEnabled,
      createdAt: profile.createdAt,
      updatedAt: DateTime.now(),
    );

    await _profiles.doc(profile.userId).set(
          updatedProfile.toJson(),
          SetOptions(merge: true),
        );

    return updatedProfile;
  }

  @override
  Future<void> deleteUserAccount({
    required String userId,
    required String reauthenticationToken,
  }) async {
    final currentUser = auth.currentUser;

    if (currentUser == null || currentUser.uid != userId) {
      throw FirebaseAuthException(
        code: 'user-mismatch',
        message: 'No authenticated user matches this profile.',
      );
    }

    final email = currentUser.email;

    if (email == null) {
      throw FirebaseAuthException(
        code: 'reauthentication-required',
      );
    }

    final credential = EmailAuthProvider.credential(
      email: email,
      password: reauthenticationToken,
    );

    await currentUser.reauthenticateWithCredential(credential);


    await _profiles.doc(userId).delete();

    await currentUser.delete();
  }
}