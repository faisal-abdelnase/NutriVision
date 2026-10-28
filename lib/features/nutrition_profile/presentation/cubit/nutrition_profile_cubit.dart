import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/nutrition_profile.dart';
import '../../domain/usecases/create_nutrition_profile.dart';
import '../../domain/usecases/get_nutrition_profile.dart';
import '../../domain/usecases/update_dietary_preferences.dart';
import '../../domain/usecases/update_nutrition_goals.dart';
import '../../domain/usecases/update_nutrition_profile.dart';
import 'nutrition_profile_state.dart';

class NutritionProfileCubit extends Cubit<NutritionProfileState> {
  final GetNutritionProfile getNutritionProfile;
  final CreateNutritionProfile createNutritionProfile;
  final UpdateNutritionProfile updateNutritionProfile;
  final UpdateNutritionGoals updateNutritionGoals;
  final UpdateDietaryPreferences updateDietaryPreferences;

  NutritionProfile? _cachedProfile;

  NutritionProfile? get currentProfile {
    final s = state;
    if (s is NutritionProfileLoaded) return s.profile;
    if (s is NutritionProfileActionSuccess) return s.profile;
    return _cachedProfile;
  }

  NutritionProfileCubit({
    required this.getNutritionProfile,
    required this.createNutritionProfile,
    required this.updateNutritionProfile,
    required this.updateNutritionGoals,
    required this.updateDietaryPreferences,
  }) : super(const NutritionProfileInitial());

  Future<void> loadInitialProfile({String? userId}) async {
    final uid = userId ?? 'guest_user';
    try {
      final profile = await getNutritionProfile(userId: uid);
      if (profile != null) {
        _cachedProfile = profile;
        emit(NutritionProfileLoaded(profile: profile));
      }
    } catch (_) {}
  }

  Future<void> fetchProfile({required String userId}) async {
    emit(const NutritionProfileLoading());

    try {
      final profile = await getNutritionProfile(userId: userId);

      if (profile == null) {
        emit(const NutritionProfileNotFound());
        return;
      }

      _cachedProfile = profile;
      emit(NutritionProfileLoaded(profile: profile));
    } catch (e) {
      emit(NutritionProfileError(message: _errorMessage(e)));
    }
  }

  Future<void> createProfile({required NutritionProfile profile}) async {
    _cachedProfile = profile;
    emit(const NutritionProfileLoading());

    try {
      final created = await createNutritionProfile(profile: profile);
      _cachedProfile = created;

      emit(
        NutritionProfileActionSuccess(
          profile: created,
          action: NutritionProfileAction.created,
        ),
      );
    } catch (e) {
      emit(NutritionProfileError(message: _errorMessage(e)));
    }
  }

  Future<void> updateProfile({required NutritionProfile profile}) async {
    emit(const NutritionProfileLoading());

    try {
      final updated = await updateNutritionProfile(profile: profile);
      _cachedProfile = updated;

      emit(
        NutritionProfileActionSuccess(
          profile: updated,
          action: NutritionProfileAction.updated,
        ),
      );
    } catch (e) {
      emit(NutritionProfileError(message: _errorMessage(e)));
    }
  }

  Future<void> updateGoals({
    required String userId,
    required double dailyCalorieTarget,
    required double proteinTargetGrams,
    required double carbohydrateTargetGrams,
    required double fatTargetGrams,
  }) async {
    emit(const NutritionProfileLoading());

    try {
      final updated = await updateNutritionGoals(
        userId: userId,
        dailyCalorieTarget: dailyCalorieTarget,
        proteinTargetGrams: proteinTargetGrams,
        carbohydrateTargetGrams: carbohydrateTargetGrams,
        fatTargetGrams: fatTargetGrams,
      );
      _cachedProfile = updated;

      emit(
        NutritionProfileActionSuccess(
          profile: updated,
          action: NutritionProfileAction.goalsUpdated,
        ),
      );
    } catch (e) {
      emit(NutritionProfileError(message: _errorMessage(e)));
    }
  }

  Future<void> updatePreferences({
    required String userId,
    required List<String> dietaryPreferences,
    required List<String> allergies,
  }) async {
    emit(const NutritionProfileLoading());

    try {
      final updated = await updateDietaryPreferences(
        userId: userId,
        dietaryPreferences: dietaryPreferences,
        allergies: allergies,
      );
      _cachedProfile = updated;

      emit(
        NutritionProfileActionSuccess(
          profile: updated,
          action: NutritionProfileAction.preferencesUpdated,
        ),
      );
    } catch (e) {
      emit(NutritionProfileError(message: _errorMessage(e)));
    }
  }

  String _errorMessage(Object error) {
    return error.toString().replaceFirst('Exception: ', '');
  }
}
