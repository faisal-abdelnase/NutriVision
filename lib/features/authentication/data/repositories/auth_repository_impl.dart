import '../../domain/entities/auth_user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<AuthUser> signIn({
    required String email,
    required String password,
  }) async {
    return remoteDataSource.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
  }

  @override
  Future<AuthUser> signUp({
    required String email,
    required String password,
  }) async {
    return remoteDataSource.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
  }

  @override
  Future<void> signOut() => remoteDataSource.signOut();

  @override
  Future<void> sendPasswordResetEmail({required String email}) {
    return remoteDataSource.sendPasswordResetEmail(email: email.trim());
  }
}
