import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/nutrition_trend_point.dart';
import '../cubit/progress_cubit.dart';
import '../cubit/progress_state.dart';

class MacronutrientTrajectoriesCard extends StatelessWidget {
  const MacronutrientTrajectoriesCard({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<ProgressCubit>().state;
    final hasData = state is ProgressSuccess;
    final List<NutritionTrendPoint> trends = state is ProgressSuccess
        ? state.nutritionTrends
        : const [];
    final days = trends.isEmpty ? 1 : trends.length;
    double average(double Function(NutritionTrendPoint) value) =>
        trends.fold<double>(0, (sum, point) => sum + value(point)) / days;
    final protein = average((point) => point.proteinGrams);
    final carbohydrates = average((point) => point.carbohydrateGrams);
    final fat = average((point) => point.fatGrams);
    final proteinTarget = trends.isEmpty
        ? null
        : trends.first.proteinTargetGrams;
    final carbohydrateTarget = trends.isEmpty
        ? null
        : trends.first.carbohydrateTargetGrams;
    final fatTarget = trends.isEmpty ? null : trends.first.fatTargetGrams;
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isSmall = constraints.maxWidth < 650;
        double itemWidth = isSmall
            ? constraints.maxWidth
            : (constraints.maxWidth - 24) / 3;

        return Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            _buildTrajectoryTile(
              'Protein Trajectory',
              proteinTarget == null
                  ? 'Target unavailable'
                  : 'Target: ${proteinTarget.toStringAsFixed(0)}g',
              hasData ? '${protein.toStringAsFixed(1)}g' : '—',
              'Daily Mean',
              'Saved meal records',
              'Seven day mean',
              AppColors.primaryTeal,
              itemWidth,
            ),
            _buildTrajectoryTile(
              'Carbohydrates',
              carbohydrateTarget == null
                  ? 'Target unavailable'
                  : 'Target: ${carbohydrateTarget.toStringAsFixed(0)}g',
              hasData ? '${carbohydrates.toStringAsFixed(1)}g' : '—',
              'Daily mean',
              'Seven day mean',
              'Saved meals',
              const Color(0xFF0284C7),
              itemWidth,
            ),
            _buildTrajectoryTile(
              'Healthy Fats & Lipids',
              fatTarget == null
                  ? 'Target unavailable'
                  : 'Target: ${fatTarget.toStringAsFixed(0)}g',
              hasData ? '${fat.toStringAsFixed(1)}g' : '—',
              'Daily mean',
              'Seven day mean',
              'Saved meals',
              const Color(0xFFEA580C),
              itemWidth,
            ),
          ],
        );
      },
    );
  }

  Widget _buildTrajectoryTile(
    String title,
    String target,
    String val,
    String sub,
    String tag1,
    String tag2,
    Color clr,
    double width,
  ) {
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
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                target,
                style: const TextStyle(fontSize: 8, color: AppColors.mutedText),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                val,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  sub,
                  style: const TextStyle(
                    fontSize: 8,
                    color: AppColors.mutedText,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          // Wave Line Placeholder
          Container(height: 20, color: clr.withValues(alpha: 0.1)),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                tag1,
                style: const TextStyle(fontSize: 7, color: AppColors.mutedText),
              ),
              Text(
                tag2,
                style: TextStyle(
                  fontSize: 7,
                  color: clr,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
