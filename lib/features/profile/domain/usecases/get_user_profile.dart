import '../entities/user_profile.dart';
import '../repositories/profile_repository.dart';

class GetUserProfile {
  final ProfileRepository repository;

  GetUserProfile(this.repository);

  Future<UserProfile?> call({
    required String userId,
  }) {
    return repository.getUserProfile(userId: userId);
  }
}