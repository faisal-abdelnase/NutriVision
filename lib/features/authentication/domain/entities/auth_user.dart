class AuthUser {
  final String id;
  final String email;
  final bool emailVerified;
  final DateTime? createdAt;
  final String? displayName;
  final String? photoUrl;

  const AuthUser({
    required this.id,
    required this.email,
    required this.emailVerified,
    this.createdAt,
    this.displayName,
    this.photoUrl,
  });
}
