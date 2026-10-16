import '../../domain/entities/auth_user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl({required this.remoteDataSource});

  final AuthRemoteDataSource remoteDataSource;

  @override
  Future<AuthUser> signIn({
    required String email,
    required String password,
  }) =>
      remoteDataSource.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

  @override
  Future<AuthUser> signUp({
    required String email,
    required String password,
  }) =>
      remoteDataSource.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

  @override
  Future<void> signOut() => remoteDataSource.signOut();

  @override
  Future<void> sendPasswordResetEmail({required String email}) =>
      remoteDataSource.sendPasswordResetEmail(email: email);
}