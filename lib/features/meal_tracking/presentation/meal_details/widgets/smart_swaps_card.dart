import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';

class SmartSwapsCard extends StatelessWidget {
  const SmartSwapsCard({super.key});

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
              Text('DYNAMIC METABOLIC OPTIMIZATION', style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: AppColors.mutedText)),
              Icon(Icons.swap_horiz, size: 16, color: AppColors.primaryTeal),
            ],
          ),
          const Text('Smart Swaps & Clinical Alternatives', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          const SizedBox(height: 12),

          LayoutBuilder(builder: (context, constraints) {
            bool isSmall = constraints.maxWidth < 500;
            return Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _buildSwapItem('Keto / Ultra-Low Carb Option', 'Swap Quinoa with Riced Cauliflower', 'Reduces carbohydrates by 38g while preserving bowl volume.', '-112 kcal net', isSmall ? constraints.maxWidth : (constraints.maxWidth - 12) / 2),
                _buildSwapItem('100% Plant-Based Day', 'Swap Salmon with Grilled Organic Tofu', 'Zero dietary cholesterol, rich in isoflavones (+32g clean protein).', '-140 kcal net', isSmall ? constraints.maxWidth : (constraints.maxWidth - 12) / 2),
              ],
            );
          })
        ],
      ),
    );
  }

  Widget _buildSwapItem(String category, String title, String desc, String kcal, double width) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: const Color(0xFFF8FAFC), borderRadius: BorderRadius.circular(10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(category, style: const TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: AppColors.primaryTeal)),
          const SizedBox(height: 2),
          Text(title, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.darkText)),
          const SizedBox(height: 2),
          Text(desc, style: const TextStyle(fontSize: 8, color: AppColors.mutedText), maxLines: 2, overflow: TextOverflow.ellipsis),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(kcal, style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: AppColors.primaryTeal)),
              OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: const Text('Preview Swap', style: TextStyle(fontSize: 8, color: AppColors.darkText)),
              )
            ],
          )
        ],
      ),
    );
  }
}