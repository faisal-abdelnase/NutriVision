import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class CaloricEquilibriumCard extends StatelessWidget {
  const CaloricEquilibriumCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          bool isWide = constraints.maxWidth >= 650;

          Widget chartWidget = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row / Legend wrapped to prevent header overflow
              Wrap(
                alignment: WrapAlignment.spaceBetween,
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 8,
                runSpacing: 6,
                children: [
                  const Text(
                    'Caloric Intake & Target Equilibrium',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      CircleAvatar(radius: 3, backgroundColor: AppColors.primaryTeal),
                      SizedBox(width: 4),
                      Text('Intake', style: TextStyle(fontSize: 8, color: AppColors.mutedText)),
                      SizedBox(width: 8),
                      CircleAvatar(radius: 3, backgroundColor: Colors.orange),
                      SizedBox(width: 4),
                      Text('Target', style: TextStyle(fontSize: 8, color: AppColors.mutedText)),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Simulated Bar Chart
              SizedBox(
                height: 120,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    _buildBar('Mon', 0.8, AppColors.primaryTeal),
                    _buildBar('Tue', 0.85, Colors.blue),
                    _buildBar('Wed', 0.8, AppColors.primaryTeal),
                    _buildBar('Thu', 0.75, AppColors.primaryTeal),
                    _buildBar('Fri', 0.95, Colors.orange),
                    _buildBar('Sat', 0.82, AppColors.primaryTeal),
                    _buildBar('Sun', 0.65, Colors.indigo),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // Footer Stats Wrapped or Flexed to completely prevent overflow
              Wrap(
                alignment: WrapAlignment.spaceBetween,
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 8,
                runSpacing: 4,
                children: const [
                  Text(
                    'Weekly Variance: Low SD (±62 kcal)',
                    style: TextStyle(fontSize: 8, color: AppColors.mutedText),
                  ),
                  Text(
                    'Net Adherence: 95.6%',
                    style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: AppColors.primaryTeal),
                  ),
                ],
              ),
            ],
          );

          Widget sideInfoWidget = Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text('Wed • Oct 24', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11)),
                    Text('1,980 kcal', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: AppColors.primaryTeal)),
                  ],
                ),
                const Text('On Target (101.5%)', style: TextStyle(fontSize: 8, color: AppColors.mutedText)),
                const SizedBox(height: 10),
                _buildMealRow('Breakfast (08:15 AM)', '490 kcal'),
                _buildMealRow('Lunch (01:30 PM)', '710 kcal'),
                _buildMealRow('Dinner (07:45 PM)', '580 kcal'),
                _buildMealRow('Snacks / Micro-Fuel', '200 kcal'),
              ],
            ),
          );

          if (isWide) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 3, child: chartWidget),
                const SizedBox(width: 16),
                Expanded(flex: 2, child: sideInfoWidget),
              ],
            );
          } else {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                chartWidget,
                const SizedBox(height: 16),
                sideInfoWidget,
              ],
            );
          }
        },
      ),
    );
  }

  Widget _buildBar(String day, double hRatio, Color clr) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: 16,
          height: 100 * hRatio,
          decoration: BoxDecoration(color: clr, borderRadius: BorderRadius.circular(4)),
        ),
        const SizedBox(height: 6),
        Text(day, style: const TextStyle(fontSize: 8, color: AppColors.mutedText)),
      ],
    );
  }

  Widget _buildMealRow(String name, String kcal) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              name,
              style: const TextStyle(fontSize: 9, color: AppColors.darkText),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            kcal,
            style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}