import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../models/auth_user_model.dart';
import 'auth_remote_data_source.dart';

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firestore;
  final GoogleSignIn googleSignIn;
  bool _googleInitialized = false;

  AuthRemoteDataSourceImpl({
    required this.firebaseAuth,
    FirebaseFirestore? firestore,
    GoogleSignIn? googleSignIn,
  }) : firestore = firestore ?? FirebaseFirestore.instance,
       googleSignIn = googleSignIn ?? GoogleSignIn.instance;

  @override
  Future<AuthUserModel?> signInWithGoogle() async {
    if (kIsWeb) {
      final result = await firebaseAuth.signInWithPopup(GoogleAuthProvider());
      final user = result.user;
      if (user != null) await _ensureUserProfile(user);
      return user == null ? null : AuthUserModel.fromFirebaseUser(user);
    }

    if (!_googleInitialized) {
      await googleSignIn.initialize();
      _googleInitialized = true;
    }
    final account = await googleSignIn.authenticate();
    final idToken = account.authentication.idToken;
    if (idToken == null) {
      throw FirebaseAuthException(code: 'invalid-credential');
    }
    final credential = GoogleAuthProvider.credential(idToken: idToken);
    final result = await firebaseAuth.signInWithCredential(credential);
    final user = result.user;
    if (user != null) await _ensureUserProfile(user);
    return user == null ? null : AuthUserModel.fromFirebaseUser(user);
  }

  Future<void> _ensureUserProfile(User user) async {
    final reference = firestore.collection('users').doc(user.uid);
    await firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(reference);
      if (snapshot.exists) return;

      transaction.set(reference, {
        'userId': user.uid,
        'fullName': user.displayName ?? '',
        'email': user.email ?? '',
        'phoneNumber': null,
        'profilePhotoUrl': user.photoURL,
        'bio': null,
        'dateOfBirth': null,
        'gender': null,
        'preferredLanguage': 'ar',
        'preferredTheme': 'system',
        'notificationsEnabled': true,
        'createdAt': (user.metadata.creationTime ?? DateTime.now())
            .toIso8601String(),
        'updatedAt': null,
      });
    });
  }

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
    final credential = await firebaseAuth.createUserWithEmailAndPassword(
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
    if (_googleInitialized) await googleSignIn.signOut();
  }

  @override
  Future<void> sendPasswordResetEmail({required String email}) async {
    await firebaseAuth.sendPasswordResetEmail(email: email.trim());
  }
}
