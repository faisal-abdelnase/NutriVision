import 'package:firebase_auth/firebase_auth.dart';

import '../models/auth_user_model.dart';
import 'auth_remote_data_source.dart';

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth firebaseAuth;

  AuthRemoteDataSourceImpl({
    required this.firebaseAuth,
  });

  @override
  Future<AuthUserModel> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    final credential = await firebaseAuth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );

    final user = credential.user;

    if (user == null) {
      throw FirebaseAuthException(
        code: 'user-not-found',
        message: 'No user returned after sign in.',
      );
    }

    return AuthUserModel.fromFirebaseUser(user);
  }

  @override
  Future<AuthUserModel> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    final credential =
        await firebaseAuth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );

    final user = credential.user;

    if (user == null) {
      throw FirebaseAuthException(
        code: 'user-not-found',
        message: 'No user returned after account creation.',
      );
    }

    return AuthUserModel.fromFirebaseUser(user);
  }

  @override
  Future<void> signOut() async {
    await firebaseAuth.signOut();
  }

  @override
  Future<void> sendPasswordResetEmail({
    required String email,
  }) async {
    await firebaseAuth.sendPasswordResetEmail(
      email: email.trim(),
    );
  }
}