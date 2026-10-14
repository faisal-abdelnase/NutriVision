
import '../repositories/auth_repository.dart';

abstract class SignOut {
  final AuthRepository repository;

  SignOut(this.repository);

  Future< void> call();
}