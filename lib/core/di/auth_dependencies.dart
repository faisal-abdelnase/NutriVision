import 'package:firebase_auth/firebase_auth.dart';

import '../../features/authentication/data/datasources/auth_remote_data_source_impl.dart';
import '../../features/authentication/data/repositories/auth_repository_impl.dart';
import '../../features/authentication/domain/repositories/auth_repository.dart';
import '../../features/authentication/domain/usecases/sign_in.dart';
import '../../features/authentication/domain/usecases/sign_up.dart';
import '../../features/authentication/domain/usecases/sign_out.dart';
import '../../features/authentication/domain/usecases/send_password_reset_email.dart';

class AuthDependencies {
  AuthDependencies() {
    final remoteDataSource = AuthRemoteDataSourceImpl(
      firebaseAuth: FirebaseAuth.instance,
    );

    final AuthRepository repository = AuthRepositoryImpl(
      remoteDataSource: remoteDataSource,
    );

    signIn = SignIn(repository);
    signUp = SignUp(repository);
    signOut = SignOut(repository);
    sendPasswordResetEmail = SendPasswordResetEmail(repository);
  }

  late final SignIn signIn;
  late final SignUp signUp;
  late final SignOut signOut;
  late final SendPasswordResetEmail sendPasswordResetEmail;
}