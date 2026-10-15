import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

import '../../domain/entities/auth_user.dart';

class AuthUserModel extends AuthUser {
  const AuthUserModel({
    required super.id,
    required super.email,
    required super.emailVerified,
    super.createdAt,
  });

  factory AuthUserModel.fromFirebaseUser(firebase_auth.User user) {
    return AuthUserModel(
      id: user.uid,
      email: user.email ?? '',
      emailVerified: user.emailVerified,
      createdAt: user.metadata.creationTime,
    );
  }
}
