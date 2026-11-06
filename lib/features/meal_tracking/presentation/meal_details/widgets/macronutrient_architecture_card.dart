import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/meal.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../nutrition_profile/presentation/cubit/nutrition_profile_cubit.dart';

class MacronutrientArchitectureCard extends StatelessWidget {
  const MacronutrientArchitectureCard({super.key, required this.meal});
  final Meal meal;

  @override
  Widget build(BuildContext context) {
    final profile = context.watch<NutritionProfileCubit?>()?.currentProfile;
    final int? targetCalories = profile?.dailyCalorieTarget?.round();
    final int? targetProtein = profile?.proteinTargetGrams?.round();
    final int? targetCarbohydrates = profile?.carbohydrateTargetGrams?.round();
    final int? targetFat = profile?.fatTargetGrams?.round();
    final int caloriePercentage = targetCalories == null || targetCalories == 0
        ? 0
        : ((meal.calories / targetCalories) * 100).round();
    final int proteinPercentage = targetProtein == null || targetProtein == 0
        ? 0
        : ((meal.proteinGrams / targetProtein) * 100).round();

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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'BIOMETRIC TELEMETRY',
                    style: TextStyle(
                      fontSize: 8,
                      fontWeight: FontWeight.bold,
                      color: AppColors.mutedText,
                    ),
                  ),
                  Text(
                    'Macronutrient Architecture',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${meal.calories.round()} KCAL',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.darkText,
                    ),
                  ),
                  Text(
                    targetCalories == null
                        ? 'Daily target unavailable'
                        : '$caloriePercentage% of $targetCalories goal',
                    style: const TextStyle(
                      fontSize: 8,
                      color: AppColors.mutedText,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),

          // 2x2 Macro Cards
          LayoutBuilder(
            builder: (context, constraints) {
              bool isSmall = constraints.maxWidth < 450;
              return Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _buildMacroBox(
                    'Protein',
                    targetProtein == null
                        ? 'Daily target unavailable'
                        : '$proteinPercentage% of daily ($targetProtein g)',
                    '${meal.proteinGrams.toStringAsFixed(1)} grams',
                    'Stimulates Muscle Protein Synthesis (MPS)',
                    const Color(0xFF0284C7),
                    isSmall
                        ? constraints.maxWidth
                        : (constraints.maxWidth - 8) / 2,
                  ),
                  _buildMacroBox(
                    'Carbohydrates',
                    targetCarbohydrates == null || targetCarbohydrates == 0
                        ? 'Target unavailable'
                        : '${((meal.carbohydrateGrams / targetCarbohydrates) * 100).round()}% of daily target',
                    '${meal.carbohydrateGrams.toStringAsFixed(1)} grams',
                    'Logged meal amount',
                    const Color(0xFF0284C7),
                    isSmall
                        ? constraints.maxWidth
                        : (constraints.maxWidth - 8) / 2,
                  ),
                  _buildMacroBox(
                    'Healthy Fats',
                    targetFat == null || targetFat == 0
                        ? 'Target unavailable'
                        : '${((meal.fatGrams / targetFat) * 100).round()}% of daily target',
                    '${meal.fatGrams.toStringAsFixed(1)} grams',
                    'Logged meal amount',
                    const Color(0xFFEA580C),
                    isSmall
                        ? constraints.maxWidth
                        : (constraints.maxWidth - 8) / 2,
                  ),
                  _buildMacroBox(
                    'Dietary Fiber',
                    'Not provided by meal data',
                    '—',
                    'This meal does not include fiber data.',
                    AppColors.primaryTeal,
                    isSmall
                        ? constraints.maxWidth
                        : (constraints.maxWidth - 8) / 2,
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 16),

          // Key Electrolytes & Minerals Section
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      '⚡ Key Electrolytes & Minerals',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: AppColors.darkText,
                      ),
                    ),
                    Text(
                      'Ion Balance',
                      style: TextStyle(fontSize: 8, color: AppColors.mutedText),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildMicroMetric('Potassium', '—', 'Not in saved meal'),
                    _buildMicroMetric('Sodium', '—', 'Not in saved meal'),
                    _buildMicroMetric('Magnesium', '—', 'Not in saved meal'),
                    _buildMicroMetric('Iron', '—', 'Not in saved meal'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMacroBox(
    String name,
    String pct,
    String grams,
    String desc,
    Color clr,
    double width,
  ) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(radius: 3, backgroundColor: clr),
              const SizedBox(width: 4),
              Text(
                name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 10,
                ),
              ),
              const Spacer(),
              Text(
                pct,
                style: const TextStyle(fontSize: 8, color: AppColors.mutedText),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            grams,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 2),
          Text(
            desc,
            style: const TextStyle(fontSize: 8, color: AppColors.mutedText),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildMicroMetric(String name, String val, String status) {
    return Column(
      children: [
        Text(
          name,
          style: const TextStyle(fontSize: 8, color: AppColors.mutedText),
        ),
        Text(
          val,
          style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
        ),
        Text(
          status,
          style: const TextStyle(
            fontSize: 7,
            color: AppColors.primaryTeal,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
