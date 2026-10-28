import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../nutrition_profile/domain/entities/nutrition_profile.dart';
import '../../../nutrition_profile/presentation/cubit/nutrition_profile_cubit.dart';

class ProgressSummaryCards extends StatelessWidget {
  const ProgressSummaryCards({super.key});

  @override
  Widget build(BuildContext context) {
    final profile = context.watch<NutritionProfileCubit?>()?.currentProfile;
    final int targetCalories = profile?.dailyCalorieTarget?.round() ?? 1950;
    final int targetProtein = profile?.proteinTargetGrams?.round() ?? 140;
    final int avgDailyCalories = (targetCalories * 0.966).round();
    final int avgDailyProtein = (targetProtein * 0.886).round();
    final String goalTag = profile != null ? profile.goalLabelEn : 'Optimal Synth';

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
              '$avgDailyCalories',
              'kcal / day',
              'Target: $targetCalories',
              '+35 kcal vs last week',
              '96.6% Met',
              itemWidth,
            ),
            _buildStatCard(
              'AVG DAILY PROTEIN',
              '$avgDailyProtein',
              'g / day',
              'Target: ${targetProtein}g',
              goalTag,
              '88.6% Goal',
              itemWidth,
            ),
            _buildStatCard(
              'GOAL ACHIEVEMENT',
              '85.7%',
              '6 of 7 Days Adherent',
              'High Euglycemic',
              '6/7',
              'Days',
              itemWidth,
              showGauge: true,
            ),
            _buildStatCard(
              'STABILITY SCORE',
              '92',
              '/ 100',
              'Tier 1 Elite',
              'Minimal Glycemic Drift',
              'SD: ±11 mg/dL',
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
