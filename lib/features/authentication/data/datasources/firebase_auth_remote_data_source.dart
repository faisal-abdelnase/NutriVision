import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/auth_user_model.dart';
import 'auth_remote_data_source.dart';

class FirebaseAuthRemoteDataSource implements AuthRemoteDataSource {
  FirebaseAuthRemoteDataSource({
    FirebaseAuth? auth,
    FirebaseFunctions? functions,
  })  : _auth = auth ?? FirebaseAuth.instance,
        _functions = functions ?? FirebaseFunctions.instance;

  final FirebaseAuth _auth;
  final FirebaseFunctions _functions;

  AuthUserModel _mapUser(User user) => AuthUserModel(
        id: user.uid,
        email: user.email ?? '',
        emailVerified: user.emailVerified,
        createdAt: user.metadata.creationTime,
      );

  @override
  Future<AuthUserModel> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    final credential = await _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
    final user = credential.user;
    if (user == null) {
      throw FirebaseAuthException(
        code: 'user-not-found',
        message: 'Firebase did not return an authenticated user.',
      );
    }
    await _functions.httpsCallable('bootstrapUser').call();
    return _mapUser(user);
  }

  @override
  Future<AuthUserModel> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
    final user = credential.user;
    if (user == null) {
      throw FirebaseAuthException(
        code: 'user-not-found',
        message: 'Firebase did not return a newly created user.',
      );
    }
    await user.sendEmailVerification();
    await _functions.httpsCallable('bootstrapUser').call();
    return _mapUser(user);
  }

  @override
  Future<void> signOut() => _auth.signOut();

  @override
  Future<void> sendPasswordResetEmail({required String email}) =>
      _auth.sendPasswordResetEmail(email: email.trim());

  Future<void> sendEmailVerification() async {
    final user = _auth.currentUser;
    if (user == null) {
      throw FirebaseAuthException(
        code: 'no-current-user',
        message: 'Sign in before requesting email verification.',
      );
    }
    await user.sendEmailVerification();
  }

  Future<AuthUserModel?> getCurrentUser({bool refresh = false}) async {
    var user = _auth.currentUser;
    if (user == null) return null;
    if (refresh) {
      await user.reload();
      user = _auth.currentUser;
    }
    return user == null ? null : _mapUser(user);
  }

  Stream<AuthUserModel?> authStateChanges() => _auth.authStateChanges().map(
        (user) => user == null ? null : _mapUser(user),
      );

  Future<bool> reloadEmailVerificationStatus() async {
    final user = _auth.currentUser;
    if (user == null) return false;
    await user.reload();
    return _auth.currentUser?.emailVerified ?? false;
  }
}