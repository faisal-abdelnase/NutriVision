import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../nutrition_profile/domain/entities/nutrition_profile.dart';
import '../../../nutrition_profile/presentation/cubit/nutrition_profile_cubit.dart';

class CoreMacronutrientsCard extends StatelessWidget {
  const CoreMacronutrientsCard({super.key});

  @override
  Widget build(BuildContext context) {
    final profile = context.watch<NutritionProfileCubit?>()?.currentProfile;
    final int targetProtein = profile?.proteinTargetGrams?.round() ?? 140;
    final int targetCarbs = profile?.carbohydrateTargetGrams?.round() ?? 250;
    final int targetFats = profile?.fatTargetGrams?.round() ?? 70;

    final int consumedProtein = (targetProtein * 0.68).round();
    final int consumedCarbs = (targetCarbs * 0.72).round();
    final int consumedFats = (targetFats * 0.74).round();

    final double proteinRatio = targetProtein > 0 ? (consumedProtein / targetProtein).clamp(0.0, 1.0) : 0.0;
    final double carbsRatio = targetCarbs > 0 ? (consumedCarbs / targetCarbs).clamp(0.0, 1.0) : 0.0;
    final double fatsRatio = targetFats > 0 ? (consumedFats / targetFats).clamp(0.0, 1.0) : 0.0;

    final int proteinRemaining = (targetProtein - consumedProtein).clamp(0, targetProtein);
    final int carbsRemaining = (targetCarbs - consumedCarbs).clamp(0, targetCarbs);
    final int fatsRemaining = (targetFats - consumedFats).clamp(0, targetFats);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Text(
                    'Core Macronutrients',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                  if (profile != null && profile.isCalibrated) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.primaryTeal.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        profile.regimenLabelEn,
                        style: const TextStyle(
                          fontSize: 9,
                          color: AppColors.primaryTeal,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              const Icon(Icons.tune, size: 16, color: AppColors.mutedText),
            ],
          ),
          const SizedBox(height: 12),

          // Protein Progress
          _buildMacroRow(
            'Protein',
            '${consumedProtein}g / ${targetProtein}g',
            '(${(proteinRatio * 100).round()}%)',
            proteinRatio,
            const Color(0xFF0284C7),
          ),
          Text(
            'Muscle protein synthesis gate: 30g/meal    -${proteinRemaining}g to target',
            style: const TextStyle(fontSize: 9, color: AppColors.mutedText),
          ),
          const SizedBox(height: 10),

          // Carbohydrates Progress
          _buildMacroRow(
            'Carbohydrates',
            '${consumedCarbs}g / ${targetCarbs}g',
            '(${(carbsRatio * 100).round()}%)',
            carbsRatio,
            const Color(0xFF0284C7),
          ),
          Text(
            'Complex: ${(consumedCarbs * 0.79).round()}g • Simple: ${(consumedCarbs * 0.21).round()}g    -${carbsRemaining}g to target',
            style: const TextStyle(fontSize: 9, color: AppColors.mutedText),
          ),
          const SizedBox(height: 10),

          // Dietary Fats Progress
          _buildMacroRow(
            'Dietary Fats',
            '${consumedFats}g / ${targetFats}g',
            '(${(fatsRatio * 100).round()}%)',
            fatsRatio,
            const Color(0xFFEA580C),
          ),
          Text(
            'MUFA/PUFA ratio: 3.4 (Optimal)    -${fatsRemaining}g to target',
            style: const TextStyle(fontSize: 9, color: AppColors.mutedText),
          ),
          const SizedBox(height: 12),

          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: const [
                    Icon(Icons.grass, size: 14, color: AppColors.primaryTeal),
                    SizedBox(width: 6),
                    Text(
                      'Dietary Fiber\nGut Microbiome Index',
                      style: TextStyle(fontSize: 9, color: AppColors.mutedText),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: const [
                    Text(
                      '28 / 38 g',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryTeal,
                      ),
                    ),
                    Text(
                      '73% Complete',
                      style: TextStyle(fontSize: 8, color: AppColors.mutedText),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMacroRow(
    String title,
    String amount,
    String percent,
    double progress,
    Color color,
  ) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                CircleAvatar(radius: 3, backgroundColor: color),
                const SizedBox(width: 6),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            Text(
              '$amount $percent',
              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 4),
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
