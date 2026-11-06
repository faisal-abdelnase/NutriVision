import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../cubit/progress_cubit.dart';
import '../cubit/progress_state.dart';
import '../../domain/entities/nutrition_trend_point.dart';

class CaloricEquilibriumCard extends StatelessWidget {
  const CaloricEquilibriumCard({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<ProgressCubit>().state;
    final List<NutritionTrendPoint> trends = state is ProgressSuccess
        ? state.nutritionTrends
        : const [];
    final latest = trends.isEmpty ? null : trends.last;
    final targetCalories = latest?.calorieTarget;
    final todayCalories = latest?.calories ?? 0;
    final maxCalories = trends.fold<double>(
      targetCalories ?? 0,
      (maximum, point) => point.calories > maximum ? point.calories : maximum,
    );
    final scale = maxCalories <= 0 ? 1.0 : maxCalories;
    final totalMeals = trends.fold<int>(
      0,
      (count, point) => count + point.mealCount,
    );

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          bool isWide = constraints.maxWidth >= 650;

          Widget chartWidget = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row / Legend wrapped to prevent header overflow
              Wrap(
                alignment: WrapAlignment.spaceBetween,
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 8,
                runSpacing: 6,
                children: [
                  Text(
                    'Caloric Intake & Target Equilibrium',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      CircleAvatar(
                        radius: 3,
                        backgroundColor: AppColors.primaryTeal,
                      ),
                      SizedBox(width: 4),
                      Text(
                        'Intake',
                        style: TextStyle(
                          fontSize: 8,
                          color: AppColors.mutedText,
                        ),
                      ),
                      SizedBox(width: 8),
                      CircleAvatar(radius: 3, backgroundColor: Colors.orange),
                      SizedBox(width: 4),
                      Text(
                        'Target',
                        style: TextStyle(
                          fontSize: 8,
                          color: AppColors.mutedText,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Simulated Bar Chart
              SizedBox(
                height: 120,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    for (final point in trends)
                      _buildBar(
                        _weekday(point.date),
                        point.calories / scale,
                        point.calorieTarget != null &&
                                point.calories > point.calorieTarget!
                            ? Colors.orange
                            : AppColors.primaryTeal,
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // Footer Stats Wrapped or Flexed to completely prevent overflow
              Wrap(
                alignment: WrapAlignment.spaceBetween,
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 8,
                runSpacing: 4,
                children: [
                  Text(
                    'Total meals logged: $totalMeals',
                    style: TextStyle(fontSize: 8, color: AppColors.mutedText),
                  ),
                  Text(
                    targetCalories == null
                        ? 'Calorie target unavailable'
                        : 'Daily target: ${targetCalories.round()} kcal',
                    style: TextStyle(
                      fontSize: 8,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryTeal,
                    ),
                  ),
                ],
              ),
            ],
          );

          Widget sideInfoWidget = Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      latest == null ? 'Today' : _date(latest.date),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                      ),
                    ),
                    Text(
                      latest == null ? '—' : '${todayCalories.round()} kcal',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        color: AppColors.primaryTeal,
                      ),
                    ),
                  ],
                ),
                Text(
                  targetCalories == null
                      ? 'Nutrition target unavailable'
                      : 'Target: ${targetCalories.round()} kcal',
                  style: const TextStyle(
                    fontSize: 8,
                    color: AppColors.mutedText,
                  ),
                ),
                const SizedBox(height: 10),
                _buildMealRow(
                  'Protein',
                  latest == null
                      ? '—'
                      : '${latest.proteinGrams.toStringAsFixed(1)} g',
                ),
                _buildMealRow(
                  'Carbohydrates',
                  latest == null
                      ? '—'
                      : '${latest.carbohydrateGrams.toStringAsFixed(1)} g',
                ),
                _buildMealRow(
                  'Fat',
                  latest == null
                      ? '—'
                      : '${latest.fatGrams.toStringAsFixed(1)} g',
                ),
                _buildMealRow(
                  'Meals logged',
                  latest == null ? '—' : '${latest.mealCount}',
                ),
              ],
            ),
          );

          if (isWide) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 3, child: chartWidget),
                const SizedBox(width: 16),
                Expanded(flex: 2, child: sideInfoWidget),
              ],
            );
          } else {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                chartWidget,
                const SizedBox(height: 16),
                sideInfoWidget,
              ],
            );
          }
        },
      ),
    );
  }

  Widget _buildBar(String day, double hRatio, Color clr) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: 16,
          height: 100 * hRatio,
          decoration: BoxDecoration(
            color: clr,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          day,
          style: const TextStyle(fontSize: 8, color: AppColors.mutedText),
        ),
      ],
    );
  }

  String _weekday(DateTime date) {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[date.weekday - 1];
  }

  String _date(DateTime date) =>
      '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

  Widget _buildMealRow(String name, String kcal) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              name,
              style: const TextStyle(fontSize: 9, color: AppColors.darkText),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            kcal,
            style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
