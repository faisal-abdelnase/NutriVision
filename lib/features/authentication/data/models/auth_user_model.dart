import '../../domain/entities/auth_user.dart';

class AuthUserModel extends AuthUser {
  const AuthUserModel({
    required super.id,
    required super.email,
    required super.emailVerified,
    super.createdAt,
  });

  // factory AuthUserModel.fromJson(Map<String, dynamic> json){}

  // Map<String, dynamic> toJson(){}


}