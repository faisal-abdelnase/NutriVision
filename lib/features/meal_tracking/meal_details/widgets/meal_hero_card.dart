import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class MealHeroCard extends StatelessWidget {
  const MealHeroCard({Key? key}) : super(key: key);

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
          // Banner Info Top
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: const [
                  Icon(Icons.camera_alt_outlined, size: 14, color: AppColors.mutedText),
                  SizedBox(width: 4),
                  Text('Photogrammetry: 380g Net', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.darkText)),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(color: const Color(0xFFDCFCE7), borderRadius: BorderRadius.circular(4)),
                child: const Text('99.4% Confidence', style: TextStyle(fontSize: 9, color: Color(0xFF166534), fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Meal Image with Title Overlay
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Stack(
              children: [
                Image.network(
                  'https://images.unsplash.com/photo-1546069901-ba9599a7e63c',
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (c, e, s) => Container(height: 180, color: Colors.grey.shade300, child: const Icon(Icons.fastfood, size: 40)),
                ),
                Container(
                  height: 180,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.transparent, Colors.black.withOpacity(0.8)],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 12,
                  left: 12,
                  right: 12,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text('LUNCH • 01:15 PM', style: TextStyle(color: AppColors.primaryTeal, fontSize: 10, fontWeight: FontWeight.bold)),
                      SizedBox(height: 2),
                      Text('Grilled Herb Salmon &\nQuinoa Bowl', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold, height: 1.2)),
                      SizedBox(height: 4),
                      Text('سالمون مشوي بالأعشاب مع سلطة الكينوا المغذية', style: TextStyle(color: Colors.white70, fontSize: 10)),
                    ],
                  ),
                )
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Tag Pills
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              _buildTag('Lunch • غداء', const Color(0xFFE0F2FE), const Color(0xFF0369A1)),
              _buildTag('High Omega-3 (EPA/DHA)', const Color(0xFFEFF6FF), const Color(0xFF1E40AF)),
              _buildTag('Gluten-Free', const Color(0xFFF1F5F9), AppColors.darkText),
              _buildTag('Low Glycemic (GI: 38)', const Color(0xFFDCFCE7), const Color(0xFF166534)),
            ],
          ),
          const SizedBox(height: 16),

          // NutriScore Dial Box
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: const Color(0xFFF8FAFC), borderRadius: BorderRadius.circular(12)),
            child: Row(
              children: [
                // Score Circle
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.primaryTeal, width: 3),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text('88', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.darkText)),
                      Text('NUTRI-SCORE', style: TextStyle(fontSize: 5, color: AppColors.mutedText, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text('Satiety Index 84 / 100', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.primaryTeal)),
                          Text('(High)', style: TextStyle(fontSize: 10, color: AppColors.primaryTeal, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: const [
                          Text('Lipid Profile:\nCardioprotective', style: TextStyle(fontSize: 8, color: AppColors.mutedText)),
                          Spacer(),
                          Text('Metabolic\nBurn:\nClean Energy', style: TextStyle(fontSize: 8, color: AppColors.primaryTeal, fontWeight: FontWeight.bold)),
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Clinical Disclaimer Box
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: const Color(0xFFEFF6FF), borderRadius: BorderRadius.circular(8)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Icon(Icons.verified_outlined, size: 14, color: Color(0xFF0369A1)),
                SizedBox(width: 6),
                Expanded(
                  child: Text(
                    'Clinical Notice: Estimated nutritional telemetry calibrated via dual-lens bio-photogrammetry cross-referenced with USDA FoodData Central Node SR-Legacy. Not intended as direct autonomous medical prescription.',
                    style: TextStyle(fontSize: 8, color: Color(0xFF0369A1), height: 1.3),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildTag(String text, Color bg, Color textClr) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(6)),
      child: Text(text, style: TextStyle(fontSize: 9, color: textClr, fontWeight: FontWeight.bold)),
    );
  }
}