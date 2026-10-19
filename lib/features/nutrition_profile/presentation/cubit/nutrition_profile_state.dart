
import '../../domain/entities/nutrition_profile.dart';

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