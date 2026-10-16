
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/errors/firebase_error_mapper.dart';
import '../../domain/entities/auth_user.dart';
import '../../domain/usecases/sign_in.dart';
import '../../domain/usecases/sign_up.dart';
import '../../domain/usecases/sign_out.dart';
import '../../domain/usecases/send_password_reset_email.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final SignIn signInUseCase;
  final SignUp signUpUseCase;
  final SignOut signOutUseCase;
  final SendPasswordResetEmail sendPasswordResetEmailUseCase;

  AuthCubit({
    required this.signInUseCase,
    required this.signUpUseCase,
    required this.signOutUseCase,
    required this.sendPasswordResetEmailUseCase,
  }) : super(const AuthInitial());

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    emit(const AuthLoading());

    try {
      final AuthUser user = await signInUseCase(
        email: email.trim(),
        password: password,
      );

      emit(AuthAuthenticated(user));
    } on FirebaseAuthException catch (e) {
      emit(AuthError(FirebaseErrorMapper.map(e.code)));
    } catch (_) {
      emit(const AuthError(
        'حدث خطأ غير متوقع. حاول مرة أخرى.',
      ));
    }
  }

  Future<void> signUp({
    required String email,
    required String password,
  }) async {
    emit(const AuthLoading());

    try {
      final AuthUser user = await signUpUseCase(
        email: email.trim(),
        password: password,
      );

      emit(AuthAuthenticated(user));
    } on FirebaseAuthException catch (e) {
      emit(AuthError(FirebaseErrorMapper.map(e.code)));
    } catch (_) {
      emit(const AuthError(
        'تعذر إنشاء الحساب. حاول مرة أخرى.',
      ));
    }
  }

  Future<void> signOut() async {
    emit(const AuthLoading());

    try {
      await signOutUseCase();

      emit(const AuthUnauthenticated());
    } on FirebaseAuthException catch (e) {
      emit(AuthError(FirebaseErrorMapper.map(e.code)));
    } catch (_) {
      emit(const AuthError(
        'تعذر تسجيل الخروج. حاول مرة أخرى.',
      ));
    }
  }

  Future<void> sendPasswordResetEmail({
    required String email,
  }) async {
    emit(const AuthLoading());

    try {
      await sendPasswordResetEmailUseCase(
        email: email.trim(),
      );

      emit(const AuthPasswordResetSent());
    } on FirebaseAuthException catch (e) {
      emit(AuthError(FirebaseErrorMapper.map(e.code)));
    } catch (_) {
      emit(const AuthError(
        'تعذر إرسال رسالة استعادة كلمة المرور.',
      ));
    }
  }


}
