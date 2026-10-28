import '../entities/user_profile.dart';
import '../repositories/profile_repository.dart';

class UpdateUserProfile {
  final ProfileRepository repository;

  UpdateUserProfile(this.repository);

  Future<UserProfile> call({required UserProfile profile}) {
    return repository.updateUserProfile(profile: profile);
  }
}
