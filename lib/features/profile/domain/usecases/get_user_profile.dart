

import '../entities/user_profile.dart';
import '../repositories/profile_repository.dart';

abstract class GetUserProfile {
  final ProfileRepository repository;

  GetUserProfile(this.repository);

  Future<UserProfile?> call({
    required String userId,
  });
}