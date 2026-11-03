import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/daily_nutrition_summary.dart';

class CoreMacronutrientsCard extends StatelessWidget {
  const CoreMacronutrientsCard({super.key, required this.summary});

  final DailyNutritionSummary summary;

  @override
  Widget build(BuildContext context) {
    final targets = [
      summary.proteinTargetGrams,
      summary.carbohydrateTargetGrams,
      summary.fatTargetGrams,
    ];
    final amounts = [
      summary.consumedProteinGrams,
      summary.consumedCarbohydrateGrams,
      summary.consumedFatGrams,
    ];
    const labels = ['Protein', 'Carbohydrates', 'Dietary Fats'];
    const colors = [Color(0xFF0284C7), Color(0xFF0284C7), Color(0xFFEA580C)];
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
              'Core Macronutrients',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            ),
            const SizedBox(height: 14),
            for (var i = 0; i < labels.length; i++) ...[
              _macro(labels[i], amounts[i], targets[i], colors[i]),
              if (i < labels.length - 1) const SizedBox(height: 14),
            ],
          ],
        ),
      ),
    );
  }

  Widget _macro(String label, double consumed, double target, Color color) {
    final progress = target > 0 ? (consumed / target).clamp(0.0, 1.0) : 0.0;
    final targetText = target > 0 ? '${target.round()}g' : 'No target';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Text(
              '${consumed.round()}g / $targetText (${(progress * 100).round()}%)',
              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 5),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 6,
            backgroundColor: const Color(0xFFF1F5F9),
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }
}
