import '../repositories/auth_repository.dart';

abstract class SendPasswordResetEmail {
  final AuthRepository repository;

  SendPasswordResetEmail(this.repository);

  Future<void> call({
    required String email,
  });
}