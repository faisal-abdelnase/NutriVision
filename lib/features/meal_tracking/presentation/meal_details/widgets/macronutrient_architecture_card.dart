import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';

class MacronutrientArchitectureCard extends StatelessWidget {
  const MacronutrientArchitectureCard({super.key});

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
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text('BIOMETRIC TELEMETRY', style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: AppColors.mutedText)),
                  Text('Macronutrient Architecture', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: const [
                  Text('620 KCAL', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.darkText)),
                  Text('28% of 2,200 goal', style: TextStyle(fontSize: 8, color: AppColors.mutedText)),
                ],
              )
            ],
          ),
          const SizedBox(height: 16),

          // 2x2 Macro Cards
          LayoutBuilder(builder: (context, constraints) {
            bool isSmall = constraints.maxWidth < 450;
            return Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildMacroBox('Protein', '34% of energy', '48 grams', 'Stimulates Muscle Protein Synthesis (MPS)', const Color(0xFF0284C7), isSmall ? constraints.maxWidth : (constraints.maxWidth - 8) / 2),
                _buildMacroBox('Carbohydrates', '31% of energy', '52 grams', 'Complex slow-burning glycemic load', const Color(0xFF0284C7), isSmall ? constraints.maxWidth : (constraints.maxWidth - 8) / 2),
                _buildMacroBox('Healthy Fats', '28% of energy', '22 grams', '82% MUFA & PUFA heart-protective', const Color(0xFFEA580C), isSmall ? constraints.maxWidth : (constraints.maxWidth - 8) / 2),
                _buildMacroBox('Dietary Fiber', '31% daily target', '8.5 grams', 'Optimal microbiome probiotic motility', AppColors.primaryTeal, isSmall ? constraints.maxWidth : (constraints.maxWidth - 8) / 2),
              ],
            );
          }),
          const SizedBox(height: 16),

          // Key Electrolytes & Minerals Section
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: const Color(0xFFF8FAFC), borderRadius: BorderRadius.circular(10)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text('⚡ Key Electrolytes & Minerals', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.darkText)),
                    Text('Ion Balance', style: TextStyle(fontSize: 8, color: AppColors.mutedText)),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildMicroMetric('Potassium', '820 mg', 'Optimal 24%'),
                    _buildMicroMetric('Sodium', '380 mg', 'Controlled Low'),
                    _buildMicroMetric('Magnesium', '92 mg', '22% RDA'),
                    _buildMicroMetric('Bio-Iron', '2.8 mg', '16% RDA'),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildMacroBox(String name, String pct, String grams, String desc, Color clr, double width) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(color: const Color(0xFFF8FAFC), borderRadius: BorderRadius.circular(8)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(radius: 3, backgroundColor: clr),
              const SizedBox(width: 4),
              Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 10)),
              const Spacer(),
              Text(pct, style: const TextStyle(fontSize: 8, color: AppColors.mutedText)),
            ],
          ),
          const SizedBox(height: 4),
          Text(grams, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          const SizedBox(height: 2),
          Text(desc, style: const TextStyle(fontSize: 8, color: AppColors.mutedText), maxLines: 2, overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }

  Widget _buildMicroMetric(String name, String val, String status) {
    return Column(
      children: [
        Text(name, style: const TextStyle(fontSize: 8, color: AppColors.mutedText)),
        Text(val, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
        Text(status, style: const TextStyle(fontSize: 7, color: AppColors.primaryTeal, fontWeight: FontWeight.bold)),
      ],
    );
  }
}