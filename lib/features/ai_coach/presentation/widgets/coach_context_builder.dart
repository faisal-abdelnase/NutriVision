import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../dashboard/presentation/cubit/dashboard_cubit.dart';
import '../../../dashboard/presentation/cubit/dashboard_state.dart';
import '../../../nutrition_profile/domain/entities/nutrition_profile.dart';
import '../../../nutrition_profile/presentation/cubit/nutrition_profile_cubit.dart';
import '../../../nutrition_profile/presentation/cubit/nutrition_profile_state.dart';
import '../models/coach_context.dart';

/// Combines the Dashboard and NutritionProfile cubits into a [CoachContext].
class CoachContextBuilder extends StatelessWidget {
  const CoachContextBuilder({
    super.key,
    required this.userId,
    required this.builder,
  });

  final String userId;
  final Widget Function(BuildContext context, CoachContext coachContext)
      builder;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashboardCubit, DashboardState>(
      builder: (context, dashboard) {
        return BlocBuilder<NutritionProfileCubit, NutritionProfileState>(
          builder: (context, profileState) {
            NutritionProfile? profile;
            if (profileState is NutritionProfileLoaded) {
              profile = profileState.profile;
            } else if (profileState is NutritionProfileActionSuccess) {
              profile = profileState.profile;
            }

            void retry() {
              context
                  .read<DashboardCubit>()
                  .refreshDashboard(userId: userId);
              context
                  .read<NutritionProfileCubit>()
                  .fetchProfile(userId: userId);
            }

            final CoachContext coachContext;
            if (dashboard is DashboardLoaded) {
              coachContext = CoachContext(
                status: CoachContextStatus.ready,
                summary: dashboard.dailySummary,
                recentMeals: dashboard.recentMeals,
                profile: profile,
                onRetry: retry,
              );
            } else if (dashboard is DashboardError) {
              coachContext = CoachContext(
                status: CoachContextStatus.error,
                profile: profile,
                onRetry: retry,
              );
            } else {
              coachContext = CoachContext(
                status: CoachContextStatus.loading,
                profile: profile,
                onRetry: retry,
              );
            }

            return builder(context, coachContext);
          },
        );
      },
    );
  }
}
