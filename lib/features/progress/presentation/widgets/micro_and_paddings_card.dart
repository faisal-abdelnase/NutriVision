import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class MicroAndPaddingsCard extends StatelessWidget {
  const MicroAndPaddingsCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isWide = constraints.maxWidth >= 650;

        Widget microCard = Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.cardBg,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Micro-Nutrient & Hydration Compliance', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildMicroItem('Dietary Fiber', '29g', '/ 38g goal', 'Optimal Microbiome'),
                  _buildMicroItem('Sodium Intake', '1,820 mg', '(<2,300)', 'Blood Pressure Norm'),
                  _buildMicroItem('Hydration Vol', '2.4L', '/ 2.8L goal', '98% Cellular Target'),
                ],
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(color: const Color(0xFFDCFCE7), borderRadius: BorderRadius.circular(6)),
                child: Row(
                  children: const [
                    Icon(Icons.eco, size: 12, color: Color(0xFF166534)),
                    SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        'Plant Diversity Index: 28 distinct botanical species logged this week.',
                        style: TextStyle(fontSize: 8, color: Color(0xFF166534), fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        );

        Widget topFoodsCard = Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.cardBg,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Top Nutritional Pillar Foods', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
              const SizedBox(height: 8),
              _buildFoodTile('Wild Sockeye Salmon', 'EPA/DHA • 34g Bioavailable P.', '5 Logs'),
              _buildFoodTile('Fermented Sourdough', 'Probiotics • Low Glycemic Ind.', '4 Logs'),
              _buildFoodTile('Greek Probiotic Yogurt', 'Casein • Active Live Cultures', '4 Logs'),
            ],
          ),
        );

        if (isWide) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: microCard),
              const SizedBox(width: 12),
              Expanded(child: topFoodsCard),
            ],
          );
        } else {
          return Column(
            children: [
              microCard,
              const SizedBox(height: 12),
              topFoodsCard,
            ],
          );
        }
      },
    );
  }

  Widget _buildMicroItem(String label, String val, String target, String tag) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 8, color: AppColors.mutedText)),
        Text(val, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
        Text(target, style: const TextStyle(fontSize: 7, color: AppColors.mutedText)),
        const SizedBox(height: 2),
        Text(tag, style: const TextStyle(fontSize: 7, color: AppColors.primaryTeal, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildFoodTile(String title, String desc, String logs) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis),
                Text(desc, style: const TextStyle(fontSize: 8, color: AppColors.mutedText), overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(4)),
            child: Text(logs, style: const TextStyle(fontSize: 8, fontWeight: FontWeight.bold)),
          )
        ],
      ),
    );
  }
}