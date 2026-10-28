import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/ai_coach_injection.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../meal_tracking/presentation/addmeal/widgets/architecture_cards.dart';
import '../../../meal_tracking/presentation/addmeal/widgets/sidebar_widget.dart';
import '../../../meal_tracking/presentation/addmeal/widgets/top_header_bar.dart';
import '../widgets/energy_balance_card.dart';
import '../widgets/core_macronutrients_card.dart';
import '../widgets/todays_meals_card.dart';
import '../widgets/ai_insight_and_chart_card.dart';
import '../widgets/hydration_and_glucose_card.dart';

import '../cubit/dashboard_cubit.dart';
import '../cubit/dashboard_state.dart';

class DashboardScreen extends StatelessWidget {
  final String userId;

  const DashboardScreen({Key? key, this.userId = 'default_user'}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      // 👈 هنا نقوم بإنشاء الـ Cubit وتمريره وطلب تحميل البيانات مباشرة
      create: (context) => sl<DashboardCubit>()..loadDashboard(userId: userId),
      child: const DashboardView(),
    );
  }
}

class DashboardView extends StatelessWidget {
  const DashboardView({Key? key}) : super(key: key);

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
        onPressed: () {
          // يمكن هنا تنفيذ إعادة تحميل البيانات أو إضافة وجبة
          context.read<DashboardCubit>().refreshDashboard(userId: 'default_user');
        },
        backgroundColor: AppColors.primaryTeal,
        child: const Icon(Icons.refresh, color: Colors.white),
      ),
      body: Row(
        children: [
          if (isDesktop) const SidebarWidget(),
          Expanded(
            child: BlocConsumer<DashboardCubit, DashboardState>(
              listener: (context, state) {
                if (state is DashboardError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.message), backgroundColor: Colors.red),
                  );
                }
              },
              builder: (context, state) {
                if (state is DashboardLoading || state is DashboardInitial) {
                  return const Center(
                    child: CircularProgressIndicator(color: AppColors.primaryTeal),
                  );
                }

                if (state is DashboardError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline, size: 48, color: Colors.red),
                        const SizedBox(height: 12),
                        Text(state.message, style: const TextStyle(color: AppColors.darkText)),
                        const SizedBox(height: 12),
                        ElevatedButton(
                          onPressed: () {
                            context.read<DashboardCubit>().loadDashboard(userId: 'default_user');
                          },
                          child: const Text('إعادة المحاولة'),
                        ),
                      ],
                    ),
                  );
                }

                if (state is DashboardLoaded) {
                  // البيانات أصبحت جاهزة ومتاحة عبر state.dailySummary و state.recentMeals
                  return SingleChildScrollView(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const TopHeaderBar(),
                        const SizedBox(height: 16),

                        // Simulation Banner
                        _buildTelemetryBanner(),
                        const SizedBox(height: 16),

                        // Welcome Header
                        _buildWelcomeHeader(context),
                        const SizedBox(height: 20),

                        // Responsive Grid Layout
                        isDesktop ? _buildDesktopLayout() : _buildMobileLayout(),

                        const SizedBox(height: 20),
                        const ArchitectureCards(),
                      ],
                    ),
                  );
                }

                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTelemetryBanner() {
    return Container(
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
    );
  }

  Widget _buildWelcomeHeader(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
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
    });
  }

  Widget _buildDesktopLayout() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
        const Expanded(
          flex: 4,
          child: TodaysMealsCard(),
        ),
        const SizedBox(width: 16),
        const Expanded(
          flex: 3,
          child: AiInsightAndChartCard(),
        ),
      ],
    );
  }

  Widget _buildMobileLayout() {
    return Column(
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
    );
  }
}