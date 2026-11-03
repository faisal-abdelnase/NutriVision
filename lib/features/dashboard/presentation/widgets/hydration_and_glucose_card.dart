import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class HydrationAndGlucoseCard extends StatelessWidget {
  const HydrationAndGlucoseCard({super.key});

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Expanded(
        child: _unavailable(
          Icons.water_drop_outlined,
          'Hydration',
          'Hydration tracking is not connected yet.',
        ),
      ),
      const SizedBox(width: 12),
      Expanded(
        child: _unavailable(
          Icons.show_chart,
          'Glucose',
          'Glucose tracking is not connected yet.',
        ),
      ),
    ],
  );

  Widget _unavailable(IconData icon, String title, String message) => Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: AppColors.cardBg,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: AppColors.border),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: AppColors.primaryTeal),
        const SizedBox(height: 8),
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
        ),
        const SizedBox(height: 4),
        Text(
          message,
          style: const TextStyle(fontSize: 9, color: AppColors.mutedText),
        ),
      ],
    ),
  );
}
