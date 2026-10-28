import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class MacronutrientTrajectoriesCard extends StatelessWidget {
  const MacronutrientTrajectoriesCard({super.key});

  @override
  Widget build(BuildContext context) {
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
              'Target: 140g',
              '124g',
              'Daily Mean',
              'Muscle Retention Band',
              '+8g vs prior week',
              AppColors.primaryTeal,
              itemWidth,
            ),
            _buildTrajectoryTile(
              'Carbs & Glycemic Load',
              'Ceiling: 220g',
              '188g',
              'Daily Mean (eGL: 44)',
              'Fiber Ratio: 1:6.4',
              'Low Glycemic Drift',
              const Color(0xFF0284C7),
              itemWidth,
            ),
            _buildTrajectoryTile(
              'Healthy Fats & Lipids',
              'Target: 65g',
              '62g',
              'Daily Mean (MUFA 56%)',
              'Omega-3 Index: 8.2%',
              'Cardioprotective',
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
