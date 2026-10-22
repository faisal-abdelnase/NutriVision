
import '../../domain/entities/nutrition_profile.dart';

enum NutritionProfileAction {
  created,
  updated,
  goalsUpdated,
  preferencesUpdated,
}

abstract class NutritionProfileState {
  const NutritionProfileState();
}

class NutritionProfileInitial extends NutritionProfileState {
  const NutritionProfileInitial();
}

class NutritionProfileLoading extends NutritionProfileState {
  const NutritionProfileLoading();
}

class NutritionProfileLoaded extends NutritionProfileState {
  final NutritionProfile profile;

  const NutritionProfileLoaded({
    required this.profile,
  });
}

class NutritionProfileNotFound extends NutritionProfileState {
  const NutritionProfileNotFound();
}

class NutritionProfileActionSuccess
    extends NutritionProfileState {
  final NutritionProfile profile;
  final NutritionProfileAction action;

  const NutritionProfileActionSuccess({
    required this.profile,
    required this.action,
  });
}


class NutritionProfileError extends NutritionProfileState {
  final String message;

  const NutritionProfileError({
    required this.message,
  });
}
