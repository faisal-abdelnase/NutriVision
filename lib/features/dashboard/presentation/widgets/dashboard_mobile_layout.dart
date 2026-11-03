
import 'package:flutter/material.dart';
import '../cubit/dashboard_state.dart';
import 'energy_balance_card.dart';
import 'core_macronutrients_card.dart';
import 'hydration_and_glucose_card.dart';
import 'todays_meals_card.dart';
import 'ai_insight_and_chart_card.dart';

class DashboardMobileLayout extends StatelessWidget {
  const DashboardMobileLayout({
    super.key,
    required this.state,
    required this.userId,
  });

  final DashboardLoaded state;
  final String userId;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        EnergyBalanceCard(
          summary: state.dailySummary,
        ),
        const SizedBox(height: 16),
        TodaysMealsCard(
          summary: state.dailySummary,
          meals: state.recentMeals,
          userId: userId,
        ),
        const SizedBox(height: 16),
        CoreMacronutrientsCard(
          summary: state.dailySummary,
        ),
        const SizedBox(height: 16),
        AiInsightAndChartCard(
          summary: state.dailySummary,
          userId: userId,
        ),
        const SizedBox(height: 16),
        const HydrationAndGlucoseCard(),
      ],
    );
  }
}
