import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../ai_coach/presentation/pages/ai_coach_page.dart';
import '../../domain/entities/daily_nutrition_summary.dart';

class AiInsightAndChartCard extends StatelessWidget {
  const AiInsightAndChartCard({
    super.key,
    required this.summary,
    required this.userId,
  });
  final DailyNutritionSummary summary;
  final String userId;

  @override
  Widget build(BuildContext context) {
    final target = summary.calorieTarget;
    final ratio = target > 0
        ? (summary.consumedCalories / target).clamp(0.0, 1.0)
        : 0.0;
    return Column(
      children: [
        Card(
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
                const Row(
                  children: [
                    Icon(
                      Icons.auto_awesome,
                      color: AppColors.primaryTeal,
                      size: 18,
                    ),
                    SizedBox(width: 6),
                    Text(
                      'Nutrition Overview',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  target > 0
                      ? 'You have consumed ${(ratio * 100).round()}% of your daily calorie target.'
                      : 'Set a daily calorie target in your nutrition profile to track progress.',
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => AiCoachPage(userId: userId),
                      ),
                    ),
                    icon: const Icon(Icons.chat_bubble_outline, size: 16),
                    label: const Text('Ask AI Nutrition Coach'),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Card(
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
                  'Today’s calorie progress',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                ),
                const SizedBox(height: 12),
                LinearProgressIndicator(
                  value: ratio,
                  minHeight: 8,
                  color: AppColors.primaryTeal,
                  backgroundColor: const Color(0xFFE2E8F0),
                ),
                const SizedBox(height: 8),
                Text(
                  '${summary.consumedCalories.round()} / ${summary.calorieTarget.round()} kcal',
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
