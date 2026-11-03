// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// import '../../../../core/di/dashboard_injection.dart';
// import '../../../../core/theme/app_colors.dart';
// import '../../../meal_tracking/presentation/addmeal/widgets/architecture_cards.dart';
// import '../../../meal_tracking/presentation/addmeal/widgets/top_header_bar.dart';
// import '../../../progress/presentation/screens/progress_screen.dart';
// import '../cubit/dashboard_cubit.dart';
// import '../cubit/dashboard_state.dart';
// import '../widgets/ai_insight_and_chart_card.dart';
// import '../widgets/core_macronutrients_card.dart';
// import '../widgets/energy_balance_card.dart';
// import '../widgets/hydration_and_glucose_card.dart';
// import '../widgets/todays_meals_card.dart';

// class DashboardScreen extends StatelessWidget {
//   const DashboardScreen({super.key, this.userId});

//   final String? userId;

//   @override
//   Widget build(BuildContext context) {
//     final uid = userId ?? FirebaseAuth.instance.currentUser?.uid;
//     if (uid == null || uid.trim().isEmpty) {
//       return const Scaffold(
//         body: Center(child: Text('Sign in to view your dashboard.')),
//       );
//     }
//     return BlocProvider(
//       create: (_) => sl<DashboardCubit>()..loadDashboard(userId: uid),
//       child: DashboardView(userId: uid),
//     );
//   }
// }

// class DashboardView extends StatelessWidget {
//   const DashboardView({super.key, required this.userId});
//   final String userId;

//   @override
//   Widget build(BuildContext context) {
//     final desktop = MediaQuery.sizeOf(context).width >= 900;
//     return Scaffold(
//       backgroundColor: AppColors.background,
//       appBar: desktop
//           ? null
//           : AppBar(
//               title: const Text('NutriVision'),
//               backgroundColor: Theme.of(context).colorScheme.surface,
//             ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () =>
//             context.read<DashboardCubit>().refreshDashboard(userId: userId),
//         backgroundColor: AppColors.primaryTeal,
//         child: const Icon(Icons.refresh, color: Colors.white),
//       ),
//       body: BlocBuilder<DashboardCubit, DashboardState>(
//         builder: (context, state) {
//           if (state is DashboardLoading || state is DashboardInitial)
//             return const Center(
//               child: CircularProgressIndicator(color: AppColors.primaryTeal),
//             );
//           if (state is DashboardError)
//             return Center(
//               child: Padding(
//                 padding: const EdgeInsets.all(24),
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     const Icon(
//                       Icons.error_outline,
//                       size: 48,
//                       color: Colors.red,
//                     ),
//                     const SizedBox(height: 12),
//                     Text(state.message, textAlign: TextAlign.center),
//                     const SizedBox(height: 12),
//                     ElevatedButton(
//                       onPressed: () => context
//                           .read<DashboardCubit>()
//                           .loadDashboard(userId: userId),
//                       child: const Text('Retry'),
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           if (state is! DashboardLoaded) return const SizedBox.shrink();
//           final content = SingleChildScrollView(
//             physics: const AlwaysScrollableScrollPhysics(),
//             padding: const EdgeInsets.all(16),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const TopHeaderBar(),
//                 const SizedBox(height: 16),
//                 Row(
//                   children: [
//                     const Expanded(
//                       child: Text(
//                         'Your nutrition overview for today',
//                         style: TextStyle(
//                           fontSize: 20,
//                           fontWeight: FontWeight.bold,
//                           color: AppColors.darkText,
//                         ),
//                       ),
//                     ),
//                     TextButton.icon(
//                       onPressed: () => Navigator.of(context).push(
//                         MaterialPageRoute<void>(
//                           builder: (_) => const ProgressScreen(),
//                         ),
//                       ),
//                       icon: const Icon(Icons.show_chart),
//                       label: const Text('View Progress'),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 16),
//                 if (desktop)
//                   Row(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Expanded(
//                         flex: 3,
//                         child: Column(
//                           children: [
//                             EnergyBalanceCard(summary: state.dailySummary),
//                             const SizedBox(height: 16),
//                             CoreMacronutrientsCard(summary: state.dailySummary),
//                             const SizedBox(height: 16),
//                             const HydrationAndGlucoseCard(),
//                           ],
//                         ),
//                       ),
//                       const SizedBox(width: 16),
//                       Expanded(
//                         flex: 4,
//                         child: TodaysMealsCard(
//                           summary: state.dailySummary,
//                           meals: state.recentMeals,
//                           userId: userId,
//                         ),
//                       ),
//                       const SizedBox(width: 16),
//                       Expanded(
//                         flex: 3,
//                         child: AiInsightAndChartCard(
//                           summary: state.dailySummary,
//                           userId: userId,
//                         ),
//                       ),
//                     ],
//                   )
//                 else
//                   Column(
//                     children: [
//                       EnergyBalanceCard(summary: state.dailySummary),
//                       const SizedBox(height: 16),
//                       TodaysMealsCard(
//                         summary: state.dailySummary,
//                         meals: state.recentMeals,
//                         userId: userId,
//                       ),
//                       const SizedBox(height: 16),
//                       CoreMacronutrientsCard(summary: state.dailySummary),
//                       const SizedBox(height: 16),
//                       AiInsightAndChartCard(
//                         summary: state.dailySummary,
//                         userId: userId,
//                       ),
//                       const SizedBox(height: 16),
//                       const HydrationAndGlucoseCard(),
//                     ],
//                   ),
//                 const SizedBox(height: 20),
//                 const ArchitectureCards(),
//               ],
//             ),
//           );
//           return RefreshIndicator(
//             onRefresh: () =>
//                 context.read<DashboardCubit>().refreshDashboard(userId: userId),
//             child: content,
//           );
//         },
//       ),
//     );
//   }
// }



import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/dashboard_injection.dart';
import '../cubit/dashboard_cubit.dart';
import '../widgets/dashboard_view.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({
    super.key,
    this.userId,
  });

  final String? userId;

  @override
  Widget build(BuildContext context) {
    final uid = userId ?? FirebaseAuth.instance.currentUser?.uid;

    if (uid == null || uid.trim().isEmpty) {
      return const Scaffold(
        body: Center(
          child: Text('Sign in to view your dashboard.'),
        ),
      );
    }

    return BlocProvider(
      create: (_) => sl<DashboardCubit>()
        ..loadDashboard(userId: uid),
      child: DashboardView(userId: uid),
    );
  }
}
