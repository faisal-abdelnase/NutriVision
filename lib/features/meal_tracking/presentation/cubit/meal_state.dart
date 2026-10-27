
import '../../domain/entities/meal.dart';

abstract class MealState {
  const MealState();
}

class MealInitial extends MealState {
  const MealInitial();
}

class MealLoading extends MealState {
  const MealLoading();
}

class MealHistoryLoaded extends MealState {
  final List<Meal> meals;
  final int page;
  final bool hasMore;

  const MealHistoryLoaded({
    required this.meals,
    required this.page,
    required this.hasMore,
  });
}

class MealDetailsLoaded extends MealState {
  final Meal meal;

  const MealDetailsLoaded(this.meal);
}

class MealsByDateLoaded extends MealState {
  final List<Meal> meals;
  final DateTime date;

  const MealsByDateLoaded({
    required this.meals,
    required this.date,
  });
}

class MealOperationSuccess extends MealState {
  final String message;
  final Meal? meal;

  const MealOperationSuccess(this.message, {this.meal});
}

class MealError extends MealState {
  final String message;

  const MealError(this.message);
}
