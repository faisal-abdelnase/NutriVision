import '../entities/auth_user.dart';
import '../repositories/auth_repository.dart';

abstract class SignUp {
  final AuthRepository repository;

  SignUp(this.repository);

  Future<AuthUser> call({
    required String email,
    required String password,
  });
}