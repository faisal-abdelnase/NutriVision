import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class CoreMacronutrientsCard extends StatelessWidget {
  const CoreMacronutrientsCard({super.key});

  @override
  Widget build(BuildContext context) {
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
            children: const [
              Text('Core Macronutrients', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              Icon(Icons.tune, size: 16, color: AppColors.mutedText),
            ],
          ),
          const SizedBox(height: 12),

          // Protein Progress
          _buildMacroRow('Protein', '95g / 140g', '(68%)', 0.68, const Color(0xFF0284C7)),
          const Text('Muscle protein synthesis gate: 30g/meal    -45g to target', style: TextStyle(fontSize: 9, color: AppColors.mutedText)),
          const SizedBox(height: 10),

          // Carbohydrates Progress
          _buildMacroRow('Carbohydrates', '180g / 250g', '(72%)', 0.72, const Color(0xFF0284C7)),
          const Text('Complex: 142g • Simple: 38g    -70g to target', style: TextStyle(fontSize: 9, color: AppColors.mutedText)),
          const SizedBox(height: 10),

          // Dietary Fats Progress
          _buildMacroRow('Dietary Fats', '52g / 70g', '(74%)', 0.74, const Color(0xFFEA580C)),
          const Text('MUFA/PUFA ratio: 3.4 (Optimal)    -18g to target', style: TextStyle(fontSize: 9, color: AppColors.mutedText)),
          const SizedBox(height: 12),

          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: const Color(0xFFF8FAFC), borderRadius: BorderRadius.circular(8)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: const [
                    Icon(Icons.grass, size: 14, color: AppColors.primaryTeal),
                    SizedBox(width: 6),
                    Text('Dietary Fiber\nGut Microbiome Index', style: TextStyle(fontSize: 9, color: AppColors.mutedText)),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: const [
                    Text('28 / 38 g', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.primaryTeal)),
                    Text('73% Complete', style: TextStyle(fontSize: 8, color: AppColors.mutedText)),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildMacroRow(String title, String amount, String percent, double progress, Color color) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                CircleAvatar(radius: 3, backgroundColor: color),
                const SizedBox(width: 6),
                Text(title, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
              ],
            ),
            Text('$amount $percent', style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
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