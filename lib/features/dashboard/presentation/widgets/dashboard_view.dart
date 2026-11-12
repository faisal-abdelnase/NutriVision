import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../cubit/dashboard_cubit.dart';
import '../cubit/dashboard_state.dart';
import 'dashboard_app_bar.dart';
import 'dashboard_body.dart';
import 'dashboard_error_view.dart';
import 'dashboard_loading_view.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key, required this.userId});

  final String userId;

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView>
    with WidgetsBindingObserver {
  Timer? _dayChangeTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _scheduleDayChangeRefresh();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _dayChangeTimer?.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _refreshForCurrentDay();
      _scheduleDayChangeRefresh();
    }
  }

  void _scheduleDayChangeRefresh() {
    _dayChangeTimer?.cancel();
    final now = DateTime.now();
    final nextDay = DateTime(now.year, now.month, now.day + 1);
    _dayChangeTimer = Timer(nextDay.difference(now), () {
      _refreshForCurrentDay();
      _scheduleDayChangeRefresh();
    });
  }

  void _refreshForCurrentDay() {
    if (!mounted) return;
    context.read<DashboardCubit>().refreshDashboard(userId: widget.userId);
  }

  bool _isDesktop(BuildContext context) {
    return MediaQuery.sizeOf(context).width >= 900;
  }

  @override
  Widget build(BuildContext context) {
    final desktop = _isDesktop(context);

    return Scaffold(
      appBar: desktop ? null : const DashboardAppBar(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.read<DashboardCubit>().refreshDashboard(
            userId: widget.userId,
          );
        },
        backgroundColor: AppColors.primaryTeal,
        child: const Icon(Icons.refresh, color: Colors.white),
      ),
      body: BlocBuilder<DashboardCubit, DashboardState>(
        builder: (context, state) {
          if (state is DashboardInitial || state is DashboardLoading) {
            return const DashboardLoadingView();
          }

          if (state is DashboardError) {
            return DashboardErrorView(
              message: state.message,
              onRetry: () {
                context.read<DashboardCubit>().loadDashboard(
                  userId: widget.userId,
                );
              },
            );
          }

          if (state is DashboardLoaded) {
            return RefreshIndicator(
              onRefresh: () {
                return context.read<DashboardCubit>().refreshDashboard(
                  userId: widget.userId,
                );
              },
              child: DashboardBody(
                state: state,
                userId: widget.userId,
                isDesktop: desktop,
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
