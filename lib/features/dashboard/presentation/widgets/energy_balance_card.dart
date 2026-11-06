import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/daily_nutrition_summary.dart';

class EnergyBalanceCard extends StatelessWidget {
  const EnergyBalanceCard({super.key, required this.summary});

  final DailyNutritionSummary summary;

  @override
  Widget build(BuildContext context) {
    final target = summary.calorieTarget;
    final consumed = summary.consumedCalories;
    final progress = target > 0 ? (consumed / target).clamp(0.0, 1.0) : 0.0;
    final remaining = (target - consumed).clamp(0.0, double.infinity);
    return Card(
      color: AppColors.cardBg,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppColors.border),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Energy Balance',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            ),
            const SizedBox(height: 16),
            Center(
              child: SizedBox(
                width: 140,
                height: 140,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 130,
                      height: 130,
                      child: CircularProgressIndicator(
                        value: progress,
                        strokeWidth: 10,
                        strokeCap: StrokeCap.round,
                        backgroundColor: Colors.grey.shade200,
                        color: AppColors.primaryTeal,
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          consumed.round().toString(),
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: AppColors.darkText,
                          ),
                        ),
                        const Text(
                          'KCAL',
                          style: TextStyle(
                            fontSize: 9,
                            color: AppColors.mutedText,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          target > 0
                              ? '${remaining.round()} KCAL Remaining'
                              : 'Daily target unavailable',
                          style: const TextStyle(
                            fontSize: 9,
                            color: AppColors.primaryTeal,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _metric(
                  'Daily Target',
                  target > 0 ? '${target.round()} kcal' : 'No target',
                ),
                _metric('Consumed', '${(progress * 100).round()}%'),
                _metric('Meals', '${summary.mealCount}'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _metric(String label, String value) => Column(
    children: [
      Text(
        label,
        style: const TextStyle(fontSize: 9, color: AppColors.mutedText),
      ),
      const SizedBox(height: 2),
      Text(
        value,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: AppColors.darkText,
        ),
      ),
    ],
  );
}
