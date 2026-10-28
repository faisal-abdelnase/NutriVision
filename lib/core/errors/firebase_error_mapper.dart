class FirebaseErrorMapper {
  FirebaseErrorMapper._();

  static String map(String code) {
    switch (code) {
      case 'invalid-email':
        return 'The email address is incorrect.';

      case 'user-not-found':
      case 'wrong-password':
      case 'invalid-credential':
        return 'The email address or password is incorrect.';

      case 'email-already-in-use':
        return 'The email address is already in use by another account.';

      case 'weak-password':
        return 'The password is too weak. Please choose a stronger password.';

      case 'too-many-requests':
        return 'You have made too many requests in a short period. Please try again later.';

      case 'network-request-failed':
        return 'There was a network error. Please check your internet connection and try again.';

      case 'operation-not-allowed':
        return 'This operation is not allowed. Please contact support for assistance.';

      case 'user-disabled':
        return 'This user account has been disabled. Please contact support for assistance.';

      case 'requires-recent-login':
        return 'This operation requires recent authentication. Please sign in again and try again.';

      default:
        return 'An error occurred while executing the operation. Please try again.';
    }
  }
}
