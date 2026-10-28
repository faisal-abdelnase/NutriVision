class AuthUser {
  final String id;
  final String email;
  final bool emailVerified;
  final DateTime? createdAt;

  const AuthUser({
    required this.id,
    required this.email,
    required this.emailVerified,
    this.createdAt,
  });
}
