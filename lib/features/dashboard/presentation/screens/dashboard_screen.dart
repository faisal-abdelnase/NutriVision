import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

import '../../meal_tracking/addmeal/widgets/architecture_cards.dart';
import '../../meal_tracking/addmeal/widgets/sidebar_widget.dart';
import '../../meal_tracking/addmeal/widgets/top_header_bar.dart';
import '../widgets/energy_balance_card.dart';
import '../widgets/core_macronutrients_card.dart';
import '../widgets/todays_meals_card.dart';
import '../widgets/ai_insight_and_chart_card.dart';
import '../widgets/hydration_and_glucose_card.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = MediaQuery.of(context).size.width >= 900;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: !isDesktop
          ? AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.darkText),
        title: const Text('NutriVision Clinical', style: TextStyle(color: AppColors.darkText, fontSize: 16)),
      )
          : null,
      drawer: !isDesktop ? const Drawer(child: SidebarWidget()) : null,
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: AppColors.primaryTeal,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: Row(
        children: [
          // Sidebar
          if (isDesktop) const SidebarWidget(),

          // Main Dashboard Body
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const TopHeaderBar(),
                  const SizedBox(height: 16),

                  // Simulation Banner (مع استخدام LayoutBuilder لمنع أي Overflow نهائياً)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEFF6FF),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        if (constraints.maxWidth < 650) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Row(
                                children: [
                                  CircleAvatar(radius: 4, backgroundColor: AppColors.primaryTeal),
                                  SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      'NUTRIVISION TELEMETRY SIMULATOR',
                                      style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF1E40AF)),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 2),
                              Text('Client State: Synchronized • Desktop | Mobile', style: TextStyle(fontSize: 9, color: AppColors.mutedText)),
                            ],
                          );
                        }
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Row(
                              children: [
                                CircleAvatar(radius: 4, backgroundColor: AppColors.primaryTeal),
                                SizedBox(width: 8),
                                Text(
                                  'NUTRIVISION TELEMETRY SIMULATOR • Client State: Synchronized',
                                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF1E40AF)),
                                ),
                              ],
                            ),
                            Text('Desktop 1200+ | Tablet | Mobile', style: TextStyle(fontSize: 9, color: AppColors.mutedText)),
                          ],
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Welcome Header
                  LayoutBuilder(builder: (context, constraints) {
                    bool isSmall = constraints.maxWidth < 650;
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Wrap(
                                crossAxisAlignment: WrapCrossAlignment.center,
                                spacing: 8,
                                runSpacing: 4,
                                children: [
                                  const Text('Good morning, Dr. Rayan 👋', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.darkText)),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(color: const Color(0xFFE0F2FE), borderRadius: BorderRadius.circular(4)),
                                    child: const Text('HL7 Telemetry 94% Stable', style: TextStyle(fontSize: 9, color: Color(0xFF0369A1), fontWeight: FontWeight.bold)),
                                  )
                                ],
                              ),
                              const SizedBox(height: 2),
                              const Text('Here\'s your nutrition overview for today. Your metabolic balance is tracking at 94% consistency.', style: TextStyle(fontSize: 11, color: AppColors.mutedText)),
                            ],
                          ),
                        ),
                        if (!isSmall) ...[
                          const SizedBox(width: 8),
                          ElevatedButton.icon(
                            onPressed: () {},
                            icon: const Icon(Icons.add, size: 14),
                            label: const Text('+ Add Meal / Scan', style: TextStyle(fontSize: 11)),
                            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryTeal, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                          )
                        ]
                      ],
                    );
                  }),
                  const SizedBox(height: 20),

                  // Responsive Grid Layout
                  isDesktop
                      ? Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Column 1
                      Expanded(
                        flex: 3,
                        child: Column(
                          children: const [
                            EnergyBalanceCard(),
                            SizedBox(height: 16),
                            CoreMacronutrientsCard(),
                            SizedBox(height: 16),
                            HydrationAndGlucoseCard(),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Column 2
                      const Expanded(
                        flex: 4,
                        child: TodaysMealsCard(),
                      ),
                      const SizedBox(width: 16),
                      // Column 3
                      const Expanded(
                        flex: 3,
                        child: AiInsightAndChartCard(),
                      ),
                    ],
                  )
                      : Column(
                    children: const [
                      EnergyBalanceCard(),
                      SizedBox(height: 16),
                      TodaysMealsCard(),
                      SizedBox(height: 16),
                      CoreMacronutrientsCard(),
                      SizedBox(height: 16),
                      AiInsightAndChartCard(),
                      SizedBox(height: 16),
                      HydrationAndGlucoseCard(),
                    ],
                  ),

                  const SizedBox(height: 20),
                  const ArchitectureCards(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}