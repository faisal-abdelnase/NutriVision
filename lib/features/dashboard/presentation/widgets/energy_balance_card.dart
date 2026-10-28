import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../nutrition_profile/domain/entities/nutrition_profile.dart';
import '../../../nutrition_profile/presentation/cubit/nutrition_profile_cubit.dart';

class EnergyBalanceCard extends StatelessWidget {
  const EnergyBalanceCard({super.key});

  @override
  Widget build(BuildContext context) {
    final profile = context.watch<NutritionProfileCubit?>()?.currentProfile;
    final int targetCalories =
        (profile != null && profile.isCalibrated)
            ? (profile.dailyCalorieTarget?.round() ?? 2200)
            : 2200;
    final int consumedCalories = (targetCalories * 0.69).round();
    final int remainingCalories = (targetCalories - consumedCalories).clamp(0, targetCalories);
    final double progressValue = (consumedCalories / targetCalories).clamp(0.0, 1.0);
    final double burnRatioPercent = (consumedCalories / targetCalories) * 100;

    String metabolicZone;
    if (profile != null) {
      switch (profile.goal) {
        case 'loseWeight':
          metabolicZone = 'Lipolytic Deficit';
          break;
        case 'gainMuscle':
          metabolicZone = 'Hypertrophic Fuel';
          break;
        case 'eatHealthier':
          metabolicZone = 'Micronutrient Dense';
          break;
        default:
          metabolicZone = 'Euglycemic Balanced';
      }
    } else {
      metabolicZone = 'Euglycemic';
    }

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
                children: const [
                  Icon(
                    Icons.eco_outlined,
                    color: AppColors.primaryTeal,
                    size: 18,
                  ),
                  SizedBox(width: 6),
                  Text(
                    'Energy Balance',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  profile != null && profile.isCalibrated
                      ? 'Target: ${profile.goalLabelEn}'
                      : 'Daily Target',
                  style: const TextStyle(fontSize: 10, color: AppColors.mutedText),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Circular Progress / Gauge Meter
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
                      value: 1,
                      strokeWidth: 10,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Colors.grey.shade200,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 130,
                    height: 130,
                    child: CircularProgressIndicator(
                      value: progressValue,
                      strokeWidth: 10,
                      strokeCap: StrokeCap.round,
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        AppColors.primaryTeal,
                      ),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '$consumedCalories',
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
                      const SizedBox(height: 2),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.arrow_downward,
                            size: 10,
                            color: AppColors.primaryTeal,
                          ),
                          Text(
                            '$remainingCalories KCAL Remaining',
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
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Metrics Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildMetricItem('Target Cap', '$targetCalories kcal'),
              _buildMetricItem(
                'Burn Ratio',
                '${burnRatioPercent.toStringAsFixed(1)}%',
                valueColor: AppColors.primaryTeal,
              ),
              _buildMetricItem('Metabolic Zone', metabolicZone),
            ],
          ),
          const SizedBox(height: 12),
          Center(
            child: Text(
              profile != null && profile.isCalibrated
                  ? 'Calibrated: ${profile.weightKg}kg • ${profile.regimenLabelEn} regimen (${profile.dailyCalorieTarget} kcal/day).'
                  : 'Estimated nutrition via dual-lens CV bio-telemetry.',
              style: const TextStyle(fontSize: 9, color: AppColors.lightText),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricItem(String label, String value, {Color? valueColor}) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 9, color: AppColors.mutedText),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: valueColor ?? AppColors.darkText,
          ),
        ),
      ],
    );
  }
}
