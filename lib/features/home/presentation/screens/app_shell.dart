import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../../../core/adaptive/adaptive_navigation.dart';
import '../../../../core/adaptive/adaptive_scaffold.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/widgets/state_views.dart';
import '../../../ai_coach/presentation/pages/ai_coach_page.dart';
import '../../../dashboard/presentation/screens/dashboard_screen.dart';
import '../../../meal_analysis/domain/entities/analyzed_food_item.dart';
import '../../../meal_analysis/domain/entities/meal_analysis_result.dart';
import '../../../meal_analysis/presentation/pages/meal_analysis_page.dart';
import '../../../meal_tracking/presentation/addmeal/screens/add_meal_screen.dart';
import '../../../meal_tracking/presentation/cubit/meal_cubit.dart';
import '../../../meal_tracking/presentation/meal_details/screens/meal_details_screen.dart';
import '../../../progress/presentation/cubit/progress_cubit.dart';
import '../../../progress/presentation/screens/progress_screen.dart';

/// Main navigation shell: Dashboard / Progress / Add Meal.
class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  late final ProgressCubit _progress = GetIt.instance<ProgressCubit>();
  late final MealCubit _meal = GetIt.instance<MealCubit>();
  int _index = 0;

  @override
  void dispose() {
    _progress.close();
    _meal.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      return Scaffold(body: AppErrorView(message: context.tr('authRequired')));
    }

    final destinations = [
      AdaptiveNavItem(
        icon: Icons.dashboard_outlined,
        selectedIcon: Icons.dashboard,
        label: context.tr('navDashboard'),
      ),
      AdaptiveNavItem(
        icon: Icons.show_chart,
        selectedIcon: Icons.insights,
        label: context.tr('navProgress'),
      ),

      AdaptiveNavItem(
        icon: Icons.add_circle_outline,
        selectedIcon: Icons.add_circle,
        label: context.tr('navAddMeal'),
      ),

      AdaptiveNavItem(
        icon: Icons.details,
        selectedIcon: Icons.details_outlined,
        label: context.tr('navDetails'),
      ),
      AdaptiveNavItem(
        icon: Icons.analytics,
        selectedIcon: Icons.analytics_outlined,
        label: context.tr('navMaleAnalaysis'),
      ),
      AdaptiveNavItem(
        icon: Icons.smart_toy_outlined,
        selectedIcon: Icons.smart_button_sharp,
        label: context.tr('navMaleAnalaysis'),
      ),
    ];

    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _progress),
        BlocProvider.value(value: _meal),
      ],
      child: AdaptiveScaffold(
        destinations: destinations,
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        appBar: AppBar(title: Text(destinations[_index].label)),
        body: IndexedStack(
          index: _index,
          children: [
            DashboardScreen(userId: uid),
            ProgressScreen(),
            AddMealScreen(),
            MealDetailsScreen(),
            MealAnalysisPage(initialResult: MealAnalysisDummyData.result),
            AiCoachPage(userId: uid),
          ],
        ),
      ),
    );
  }
}

class MealAnalysisDummyData {
  static final MealAnalysisResult result = MealAnalysisResult(
    id: 'dummy_analysis_001',
    userId: 'dummy_user_001',
    sourceDescription: 'Grilled chicken with rice, broccoli and avocado',
    foodItems: const [
      AnalyzedFoodItem(
        name: 'Grilled Chicken Breast',
        estimatedQuantity: 150,
        quantityUnit: 'g',
        calories: 248,
        proteinGrams: 46.5,
        carbohydrateGrams: 0,
        fatGrams: 5.4,
        confidenceScore: 0.98,
      ),
      AnalyzedFoodItem(
        name: 'White Rice',
        estimatedQuantity: 150,
        quantityUnit: 'g',
        calories: 195,
        proteinGrams: 4,
        carbohydrateGrams: 42.5,
        fatGrams: 0.4,
        confidenceScore: 0.96,
      ),
      AnalyzedFoodItem(
        name: 'Broccoli',
        estimatedQuantity: 100,
        quantityUnit: 'g',
        calories: 34,
        proteinGrams: 2.8,
        carbohydrateGrams: 6.6,
        fatGrams: 0.4,
        confidenceScore: 0.97,
      ),
    ],
    totalCalories: 477,
    totalProteinGrams: 53.3,
    totalCarbohydrateGrams: 49.1,
    totalFatGrams: 6.2,
    analysisSummary:
        'A balanced meal rich in protein, with carbohydrates for energy '
        'and vegetables that provide essential nutrients.',
    nutritionInsights: const [
      'High protein content supports muscle recovery.',
      'Broccoli provides fiber and essential vitamins.',
      'Rice provides carbohydrates for daily energy.',
    ],
    warnings: const ['Consider whole-grain rice for additional fiber.'],
    confidenceScore: 0.97,
    analyzedAt: DateTime(2026, 10, 29, 12, 30),
  );
}
