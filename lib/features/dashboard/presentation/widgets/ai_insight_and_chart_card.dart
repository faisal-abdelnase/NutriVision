import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class AiInsightAndChartCard extends StatelessWidget {
  const AiInsightAndChartCard({super.key});

  @override
  Widget build(BuildContext context) {
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
              // تم تعديل هذا الجزء لمنع الـ Overflow باستخدام Wrap
              Wrap(
                alignment: WrapAlignment.spaceBetween,
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 8,
                runSpacing: 4,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(Icons.auto_awesome, color: AppColors.primaryTeal, size: 18),
                      SizedBox(width: 6),
                      Text('AI Clinical Insight', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(color: const Color(0xFFDCFCE7), borderRadius: BorderRadius.circular(4)),
                    child: const Text('Bio-Intel v4.2', style: TextStyle(fontSize: 8, color: Color(0xFF166534), fontWeight: FontWeight.bold)),
                  )
                ],
              ),
              const SizedBox(height: 10),
              const Text('Your protein intake is slightly below today\'s adaptive target.', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11)),
              const SizedBox(height: 2),
              const Text('Reaching your 140g baseline preserves metabolically active lean muscle tissue and moderates late-evening glycemic excursions.', style: TextStyle(fontSize: 10, color: AppColors.mutedText)),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: const Color(0xFFF8FAFC), borderRadius: BorderRadius.circular(6)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text('PRESCRIBED MACRO CORRECTION', style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: AppColors.primaryTeal)),
                    SizedBox(height: 2),
                    Text('Target 160g Baked wild sockeye salmon or Sesame-crusted tofu bowl (provides +38g Protein at ~440 kcal).', style: TextStyle(fontSize: 9, color: AppColors.darkText)),
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
                      label: const Text('Ask AI Clinical', style: TextStyle(fontSize: 10)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.darkText,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.menu_book_outlined, size: 12, color: AppColors.darkText),
                    label: const Text('Recipes', style: TextStyle(fontSize: 10, color: AppColors.darkText)),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                    ),
                  )
                ],
              )
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
                    child: Text('7-Day Glycemic & Caloric Sync', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12), overflow: TextOverflow.ellipsis),
                  ),
                  Icon(Icons.bar_chart, size: 16, color: AppColors.mutedText),
                ],
              ),
              const Text('Baseline Target: 2,200 kcal', style: TextStyle(fontSize: 9, color: AppColors.mutedText)),
              const SizedBox(height: 16),

              // Simple Bar Chart
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _buildBar('M', 0.9, '2,150'),
                  _buildBar('T', 0.95, '2,200'),
                  _buildBar('W', 0.65, '1,520', isToday: true),
                  _buildBar('T', 0.85, '2,100', isFuture: true),
                  _buildBar('F', 0.9, '2,200', isFuture: true),
                  _buildBar('S', 0.9, '2,200', isFuture: true),
                  _buildBar('S', 0.9, '2,200', isFuture: true),
                ],
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(color: const Color(0xFFDCFCE7), borderRadius: BorderRadius.circular(6)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.check_circle_outline, size: 12, color: Color(0xFF166534)),
                    SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        'Weekly Adherence 92% On-Target',
                        style: TextStyle(fontSize: 10, color: Color(0xFF166534), fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              const Center(
                child: Text('Continuous CGM & Apple Health Connected', style: TextStyle(fontSize: 8, color: AppColors.lightText)),
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBar(String day, double heightRatio, String val, {bool isToday = false, bool isFuture = false}) {
    Color barColor = isToday ? AppColors.primaryTeal : (isFuture ? const Color(0xFFE2E8F0) : const Color(0xFF0284C7));
    return Column(
      children: [
        Text(val, style: TextStyle(fontSize: 7, color: isToday ? AppColors.primaryTeal : AppColors.mutedText, fontWeight: FontWeight.bold)),
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
        Text(day, style: const TextStyle(fontSize: 9, color: AppColors.mutedText)),
      ],
    );
  }
}