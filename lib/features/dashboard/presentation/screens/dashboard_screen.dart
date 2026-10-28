import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/routing/route_names.dart';
import '../../../../core/theme/app_colors.dart';

import '../../../meal_tracking/presentation/addmeal/widgets/architecture_cards.dart';
import '../../../meal_tracking/presentation/addmeal/widgets/sidebar_widget.dart';
import '../../../meal_tracking/presentation/addmeal/widgets/top_header_bar.dart';
import '../../../nutrition_profile/domain/entities/nutrition_profile.dart';
import '../../../nutrition_profile/presentation/cubit/nutrition_profile_cubit.dart';
import '../widgets/energy_balance_card.dart';
import '../widgets/core_macronutrients_card.dart';
import '../widgets/todays_meals_card.dart';
import '../widgets/ai_insight_and_chart_card.dart';
import '../widgets/hydration_and_glucose_card.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = MediaQuery.of(context).size.width >= 900;
    final profile = context.watch<NutritionProfileCubit?>()?.currentProfile;
    final isRtl =
        Directionality.of(context) == TextDirection.rtl ||
        Localizations.localeOf(context).languageCode == 'ar';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: !isDesktop
          ? AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              iconTheme: const IconThemeData(color: AppColors.darkText),
              title: const Text(
                'NutriVision Clinical',
                style: TextStyle(color: AppColors.darkText, fontSize: 16),
              ),
            )
          : null,
      drawer: !isDesktop ? const Drawer(child: SidebarWidget()) : null,
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).pushNamed(RouteNames.infoCompletion),
        backgroundColor: AppColors.primaryTeal,
        tooltip: isRtl ? 'تعديل المعايرة الغذائية' : 'Calibrate Profile',
        child: const Icon(Icons.tune_rounded, color: Colors.white),
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

                  // Simulation / Live Sync Banner
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEFF6FF),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final syncText = profile != null && profile.isCalibrated
                            ? (isRtl
                                ? 'الملف الغذائي نشط: ${profile.weightKg?.round()} كغ • ${profile.dailyCalorieTarget?.round()} سعرة/يوم • حماية الحساسية مفعلة'
                                : 'Live Telemetry Synchronized • ${profile.weightKg?.round()}kg • ${profile.dailyCalorieTarget?.round()} kcal/day • Goal: ${profile.goalLabelEn}')
                            : (isRtl
                                ? 'نظام المحاكاة الإكلينيكي • جاهز للمعايرة'
                                : 'NUTRIVISION TELEMETRY SIMULATOR • Client State: Synchronized');

                        if (constraints.maxWidth < 650) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const CircleAvatar(
                                    radius: 4,
                                    backgroundColor: AppColors.primaryTeal,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      syncText,
                                      style: const TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF1E40AF),
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 2),
                              Text(
                                isRtl
                                    ? 'تم تطبيق تفضيلاتك وموانع الحساسية تلقائياً'
                                    : 'Client State: Synchronized • Biometric Guards Active',
                                style: const TextStyle(
                                  fontSize: 9,
                                  color: AppColors.mutedText,
                                ),
                              ),
                            ],
                          );
                        }
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const CircleAvatar(
                                  radius: 4,
                                  backgroundColor: AppColors.primaryTeal,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  syncText,
                                  style: const TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF1E40AF),
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              isRtl
                                  ? 'تحديث فوري لجميع البيانات'
                                  : 'Desktop 1200+ | Tablet | Mobile',
                              style: const TextStyle(
                                fontSize: 9,
                                color: AppColors.mutedText,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Welcome Header
                  LayoutBuilder(
                    builder: (context, constraints) {
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
                                    Text(
                                      isRtl
                                          ? 'أهلاً بك، تم ربط ملفك الغذائي بنجاح 👋'
                                          : 'Welcome to NutriVision Clinical 👋',
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.darkText,
                                      ),
                                    ),
                                    if (profile != null && profile.isCalibrated) ...[
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 3,
                                        ),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFE0F2FE),
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        child: Text(
                                          isRtl
                                              ? '🎯 ${profile.goalLabelAr}'
                                              : '🎯 ${profile.goalLabelEn}',
                                          style: const TextStyle(
                                            fontSize: 10,
                                            color: Color(0xFF0369A1),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 3,
                                        ),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFDCFCE7),
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        child: Text(
                                          isRtl
                                              ? '🥗 ${profile.regimenLabelAr}'
                                              : '🥗 ${profile.regimenLabelEn}',
                                          style: const TextStyle(
                                            fontSize: 10,
                                            color: Color(0xFF166534),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      if (profile.allergies.isNotEmpty)
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 3,
                                          ),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFFFE4E6),
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          child: Text(
                                            isRtl
                                                ? '🛡️ ${profile.allergies.length} موانع حساسية نشطة'
                                                : '🛡️ ${profile.allergies.length} Allergens Active',
                                            style: const TextStyle(
                                              fontSize: 10,
                                              color: Color(0xFF9F1239),
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                    ],
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  profile != null && profile.isCalibrated
                                      ? (isRtl
                                          ? 'المستهدف اليومي المخصص: ${profile.dailyCalorieTarget?.round()} سعرة حرارية (بروتين: ${profile.proteinTargetGrams?.round()}غ • كربوهيدرات: ${profile.carbohydrateTargetGrams?.round()}غ • دهون: ${profile.fatTargetGrams?.round()}غ)'
                                          : 'Your Calibrated Target: ${profile.dailyCalorieTarget?.round()} kcal (Protein: ${profile.proteinTargetGrams?.round()}g • Carbs: ${profile.carbohydrateTargetGrams?.round()}g • Fats: ${profile.fatTargetGrams?.round()}g)')
                                      : (isRtl
                                          ? 'نظرة عامة على التغذية ومستويات التوازن الأيضي اليومية.'
                                          : 'Here\'s your nutrition overview for today. Your metabolic balance is tracking at 94% consistency.'),
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: AppColors.mutedText,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (!isSmall) ...[
                            const SizedBox(width: 8),
                            OutlinedButton.icon(
                              onPressed: () => Navigator.of(context).pushNamed(
                                RouteNames.infoCompletion,
                              ),
                              icon: const Icon(Icons.tune_rounded, size: 14),
                              label: Text(
                                isRtl ? 'تعديل المعايرة' : 'Adjust Profile',
                                style: const TextStyle(fontSize: 11),
                              ),
                              style: OutlinedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ],
                        ],
                      );
                    },
                  ),
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
                            const Expanded(flex: 4, child: TodaysMealsCard()),
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
