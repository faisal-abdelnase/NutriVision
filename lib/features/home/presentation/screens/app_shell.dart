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
        onDestinationSelected: (i) {
          setState(() => _index = i);
          if (i == 1) {
            final now = DateTime.now();
            _progress.loadProgress(
              userId: uid,
              startDate: DateTime(
                now.year,
                now.month,
                now.day,
              ).subtract(const Duration(days: 6)),
              endDate: DateTime(
                now.year,
                now.month,
                now.day,
              ).add(const Duration(days: 1)),
            );
          }
        },
        appBar: AppBar(title: Text(destinations[_index].label)),
        body: IndexedStack(
          index: _index,
          children: [
            DashboardScreen(userId: uid),
            ProgressScreen(),
            AddMealScreen(onBack: () => setState(() => _index = 0)),
            MealDetailsScreen(),
            AiCoachPage(userId: uid),
          ],
        ),
      ),
    );
  }
}
