import '../../domain/entities/auth_user.dart';

sealed class AuthState {
  const AuthState();
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

class AuthAuthenticated extends AuthState {
  final AuthUser user;

  const AuthAuthenticated(this.user);
}

class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}

class AuthPasswordResetSent extends AuthState {
  const AuthPasswordResetSent();
}


class AuthError extends AuthState {
  final String message;

  const AuthError(this.message);
}