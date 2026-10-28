import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../nutrition_profile/domain/entities/nutrition_profile.dart';
import '../../../nutrition_profile/presentation/cubit/nutrition_profile_cubit.dart';

class AiInsightAndChartCard extends StatelessWidget {
  const AiInsightAndChartCard({super.key});

  @override
  Widget build(BuildContext context) {
    final profile = context.watch<NutritionProfileCubit?>()?.currentProfile;
    final int targetCalories = profile?.dailyCalorieTarget?.round() ?? 2200;
    final int targetProtein = profile?.proteinTargetGrams?.round() ?? 140;
    final int todayConsumed = (targetCalories * 0.69).round();
    final double todayProgress = (todayConsumed / targetCalories).clamp(0.0, 1.0);

    String insightTitle;
    String insightBody;
    String macroCorrection;

    final hasSeafoodAllergy = profile?.containsAllergen('seafood') ?? false;
    final hasDairyAllergy = profile?.containsAllergen('dairy') ?? false;
    final isVegan = profile?.regimenName == 'vegan' || profile?.regimenName == 'vegetarian';

    if (profile != null && profile.isCalibrated) {
      switch (profile.goal) {
        case 'loseWeight':
          insightTitle = 'Adaptive Caloric Deficit Active';
          insightBody =
              'Intake is regulated toward $targetCalories kcal/day. Sustaining this rate protects lean muscle while promoting steady adipose oxidation.';
          break;
        case 'gainMuscle':
          insightTitle = 'Hypertrophic Leucine Trigger Optimized';
          insightBody =
              'Reaching your ${targetProtein}g target maximizes muscle protein synthesis (MPS) across your metabolic window.';
          break;
        case 'eatHealthier':
          insightTitle = 'Clean Fuel & Micronutrient Balance';
          insightBody =
              'Your ${profile.regimenLabelEn} protocol stabilizes glucose variability and supports optimal cellular longevity.';
          break;
        default:
          insightTitle = 'Metabolic Equilibrium Maintained';
          insightBody =
              'Caloric intake and macronutrients are calibrated to sustain your ${profile.weightKg}kg baseline weight safely.';
      }

      if (isVegan) {
        macroCorrection =
            'Target 180g Sesame-crusted Tempeh or Sprouted Lentil bowl (provides +35g Protein at ~380 kcal - 100% Plant-Based).';
      } else if (hasSeafoodAllergy) {
        macroCorrection =
            'Target 180g Herb-roasted turkey breast or Lemon chicken cutlet (provides +40g Protein at ~370 kcal - Allergen Safe).';
      } else if (hasDairyAllergy) {
        macroCorrection =
            'Target 160g Baked wild sockeye salmon with avocado salsa (provides +38g Protein at ~430 kcal - Dairy Free).';
      } else {
        macroCorrection =
            'Target 160g Baked wild sockeye salmon or Sesame-crusted tofu bowl (provides +38g Protein at ~440 kcal).';
      }
    } else {
      insightTitle = 'Protein intake is slightly below today\'s adaptive target.';
      insightBody =
          'Reaching your ${targetProtein}g baseline preserves metabolically active lean muscle tissue and moderates late-evening glycemic excursions.';
      macroCorrection =
          'Target 160g Baked wild sockeye salmon or Sesame-crusted tofu bowl (provides +38g Protein at ~440 kcal).';
    }

    return Column(
      children: [
        // AI Clinical Insight
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.cardBg,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                alignment: WrapAlignment.spaceBetween,
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 8,
                runSpacing: 4,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(
                        Icons.auto_awesome,
                        color: AppColors.primaryTeal,
                        size: 18,
                      ),
                      SizedBox(width: 6),
                      Text(
                        'AI Clinical Insight',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFDCFCE7),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      'Bio-Intel v4.2',
                      style: TextStyle(
                        fontSize: 8,
                        color: Color(0xFF166534),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                insightTitle,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
              ),
              const SizedBox(height: 2),
              Text(
                insightBody,
                style: const TextStyle(fontSize: 10, color: AppColors.mutedText),
              ),
              if (profile != null && profile.allergies.isNotEmpty) ...[
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFEF3C7),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: const Color(0xFFFDE68A)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.shield_outlined, size: 12, color: Color(0xFFB45309)),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          'Active Safeguards: Filtered for ${profile.allergies.join(", ")}',
                          style: const TextStyle(
                            fontSize: 8,
                            color: Color(0xFF92400E),
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'PRESCRIBED MACRO CORRECTION',
                      style: TextStyle(
                        fontSize: 8,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryTeal,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      macroCorrection,
                      style: const TextStyle(fontSize: 9, color: AppColors.darkText),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.chat_bubble_outline, size: 12),
                      label: const Text(
                        'Ask AI Clinical',
                        style: TextStyle(fontSize: 10),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.darkText,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.menu_book_outlined,
                      size: 12,
                      color: AppColors.darkText,
                    ),
                    label: const Text(
                      'Recipes',
                      style: TextStyle(fontSize: 10, color: AppColors.darkText),
                    ),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // 7-Day Glycemic & Caloric Sync
        Container(
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
                children: const [
                  Expanded(
                    child: Text(
                      '7-Day Glycemic & Caloric Sync',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Icon(Icons.bar_chart, size: 16, color: AppColors.mutedText),
                ],
              ),
              Text(
                'Baseline Target: $targetCalories kcal',
                style: const TextStyle(fontSize: 9, color: AppColors.mutedText),
              ),
              const SizedBox(height: 16),

              // Simple Bar Chart
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _buildBar('M', 0.9, '${(targetCalories * 0.95).round()}'),
                  _buildBar('T', 0.95, '$targetCalories'),
                  _buildBar('W', todayProgress, '$todayConsumed', isToday: true),
                  _buildBar('T', 0.85, '${(targetCalories * 0.92).round()}', isFuture: true),
                  _buildBar('F', 0.9, '$targetCalories', isFuture: true),
                  _buildBar('S', 0.9, '$targetCalories', isFuture: true),
                  _buildBar('S', 0.9, '$targetCalories', isFuture: true),
                ],
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: const Color(0xFFDCFCE7),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.check_circle_outline,
                      size: 12,
                      color: Color(0xFF166534),
                    ),
                    SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        'Weekly Adherence 92% On-Target',
                        style: TextStyle(
                          fontSize: 10,
                          color: Color(0xFF166534),
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              const Center(
                child: Text(
                  'Continuous CGM & Apple Health Connected',
                  style: TextStyle(fontSize: 8, color: AppColors.lightText),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBar(
    String day,
    double heightRatio,
    String val, {
    bool isToday = false,
    bool isFuture = false,
  }) {
    Color barColor = isToday
        ? AppColors.primaryTeal
        : (isFuture ? const Color(0xFFE2E8F0) : const Color(0xFF0284C7));
    return Column(
      children: [
        Text(
          val,
          style: TextStyle(
            fontSize: 7,
            color: isToday ? AppColors.primaryTeal : AppColors.mutedText,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 2),
        Container(
          width: 14,
          height: 60 * heightRatio,
          decoration: BoxDecoration(
            color: barColor,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          day,
          style: const TextStyle(fontSize: 9, color: AppColors.mutedText),
        ),
      ],
    );
  }
}
