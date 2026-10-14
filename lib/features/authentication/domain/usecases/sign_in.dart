
import '../entities/auth_user.dart';
import '../repositories/auth_repository.dart';

abstract class SignIn {
  final AuthRepository repository;

  SignIn(this.repository);

  Future<AuthUser> call({
    required String email,
    required String password,
  });
}