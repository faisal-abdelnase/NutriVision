import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class HydrationAndGlucoseCard extends StatelessWidget {
  const HydrationAndGlucoseCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Icon(Icons.water_drop_outlined, size: 16, color: Color(0xFF0284C7)),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(color: const Color(0xFFE0F2FE), borderRadius: BorderRadius.circular(4)),
                      child: const Text('+250ml', style: TextStyle(fontSize: 8, color: Color(0xFF0369A1), fontWeight: FontWeight.bold)),
                    )
                  ],
                ),
                const SizedBox(height: 8),
                const Text('2.1/3.0L', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const Text('Optimal Cellular Hydration', style: TextStyle(fontSize: 8, color: AppColors.mutedText)),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(2),
                  child: const LinearProgressIndicator(value: 0.7, minHeight: 4, backgroundColor: Color(0xFFE0F2FE), valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0284C7))),
                )
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Icon(Icons.show_chart, size: 16, color: AppColors.primaryTeal),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(color: const Color(0xFFDCFCE7), borderRadius: BorderRadius.circular(4)),
                      child: const Text('Steady', style: TextStyle(fontSize: 8, color: Color(0xFF166534), fontWeight: FontWeight.bold)),
                    )
                  ],
                ),
                const SizedBox(height: 8),
                const Text('98 mg/dL', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const Text('Avg Postprandial Glucose', style: TextStyle(fontSize: 8, color: AppColors.mutedText)),
                const SizedBox(height: 4),
                const Text('Variability CV: 11% (Optimal)', style: TextStyle(fontSize: 8, color: AppColors.primaryTeal, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}