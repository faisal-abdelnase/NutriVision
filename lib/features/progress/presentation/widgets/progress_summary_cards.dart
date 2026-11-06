import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../cubit/progress_cubit.dart';
import '../cubit/progress_state.dart';
import '../../domain/entities/nutrition_trend_point.dart';

class ProgressSummaryCards extends StatelessWidget {
  const ProgressSummaryCards({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<ProgressCubit>().state;
    final hasData = state is ProgressSuccess;
    final List<NutritionTrendPoint> trends = state is ProgressSuccess
        ? state.nutritionTrends
        : const [];
    final days = trends.isEmpty ? 1 : trends.length;
    final avgDailyCalories =
        trends.fold<double>(0, (sum, point) => sum + point.calories) / days;
    final avgDailyProtein =
        trends.fold<double>(0, (sum, point) => sum + point.proteinGrams) / days;
    final targetCalories = trends.isEmpty ? null : trends.first.calorieTarget;
    final targetProtein = trends.isEmpty
        ? null
        : trends.first.proteinTargetGrams;
    final totalMeals = trends.fold<int>(
      0,
      (sum, point) => sum + point.mealCount,
    );
    final calorieCompletion = targetCalories == null || targetCalories == 0
        ? null
        : avgDailyCalories / targetCalories * 100;
    final proteinCompletion = targetProtein == null || targetProtein == 0
        ? null
        : avgDailyProtein / targetProtein * 100;

    return LayoutBuilder(
      builder: (context, constraints) {
        bool isSmall = constraints.maxWidth < 600;
        double itemWidth = isSmall
            ? (constraints.maxWidth - 12) / 2
            : (constraints.maxWidth - 36) / 4;

        return Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            _buildStatCard(
              'AVG DAILY CALORIES',
              hasData ? avgDailyCalories.toStringAsFixed(0) : '—',
              'kcal / day',
              targetCalories == null
                  ? 'Target unavailable'
                  : 'Target: ${targetCalories.round()}',
              'Last 7 days',
              calorieCompletion == null
                  ? 'Target unavailable'
                  : '${calorieCompletion.toStringAsFixed(0)}% of target',
              itemWidth,
            ),
            _buildStatCard(
              'AVG DAILY PROTEIN',
              hasData ? avgDailyProtein.toStringAsFixed(1) : '—',
              'g / day',
              targetProtein == null
                  ? 'Target unavailable'
                  : 'Target: ${targetProtein.toStringAsFixed(0)}g',
              'Last 7 days',
              proteinCompletion == null
                  ? 'Target unavailable'
                  : '${proteinCompletion.toStringAsFixed(0)}% of target',
              itemWidth,
            ),
            _buildStatCard(
              'GOAL ACHIEVEMENT',
              calorieCompletion == null
                  ? '—'
                  : '${calorieCompletion.toStringAsFixed(0)}%',
              'Average calorie target',
              'Last 7 days',
              '${trends.length}',
              'Days',
              itemWidth,
              showGauge: true,
            ),
            _buildStatCard(
              'MEALS LOGGED',
              hasData ? '$totalMeals' : '—',
              'meals / 7 days',
              'From saved meals',
              'Last 7 days',
              '$totalMeals meals',
              itemWidth,
            ),
          ],
        );
      },
    );
  }

  Widget _buildStatCard(
    String title,
    String mainVal,
    String unit,
    String target,
    String tag1,
    String tag2,
    double width, {
    bool showGauge = false,
  }) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 8,
                    fontWeight: FontWeight.bold,
                    color: AppColors.mutedText,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  target,
                  style: const TextStyle(
                    fontSize: 7,
                    color: AppColors.mutedText,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Text(
                mainVal,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkText,
                ),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  unit,
                  style: const TextStyle(
                    fontSize: 9,
                    color: AppColors.mutedText,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFDCFCE7),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    tag1,
                    style: const TextStyle(
                      fontSize: 7,
                      color: Color(0xFF166534),
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              const SizedBox(width: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFFE0F2FE),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  tag2,
                  style: const TextStyle(
                    fontSize: 7,
                    color: Color(0xFF0369A1),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
