import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class EnergyBalanceCard extends StatelessWidget {
  const EnergyBalanceCard({super.key});

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
              Row(
                children: const [
                  Icon(Icons.eco_outlined, color: AppColors.primaryTeal, size: 18),
                  SizedBox(width: 6),
                  Text('Energy Balance', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(6)),
                child: const Text('Daily Target', style: TextStyle(fontSize: 10, color: AppColors.mutedText)),
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
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.grey.shade200),
                    ),
                  ),
                  SizedBox(
                    width: 130,
                    height: 130,
                    child: CircularProgressIndicator(
                      value: 0.69,
                      strokeWidth: 10,
                      strokeCap: StrokeCap.round,
                      valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primaryTeal),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text('1,520', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.darkText)),
                      Text('KCAL', style: TextStyle(fontSize: 9, color: AppColors.mutedText, fontWeight: FontWeight.bold)),
                      SizedBox(height: 2),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.arrow_downward, size: 10, color: AppColors.primaryTeal),
                          Text('680 KCAL Remaining', style: TextStyle(fontSize: 9, color: AppColors.primaryTeal, fontWeight: FontWeight.w600)),
                        ],
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Metrics Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildMetricItem('Target Cap', '2,200 kcal'),
              _buildMetricItem('Burn Ratio', '69.1%', valueColor: AppColors.primaryTeal),
              _buildMetricItem('Metabolic Zone', 'Euglycemic'),
            ],
          ),
          const SizedBox(height: 12),
          const Center(
            child: Text(
              'Estimated nutrition via dual-lens CV bio-telemetry.',
              style: TextStyle(fontSize: 9, color: AppColors.lightText),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildMetricItem(String label, String value, {Color? valueColor}) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 9, color: AppColors.mutedText)),
        const SizedBox(height: 2),
        Text(value, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: valueColor ?? AppColors.darkText)),
      ],
    );
  }
}