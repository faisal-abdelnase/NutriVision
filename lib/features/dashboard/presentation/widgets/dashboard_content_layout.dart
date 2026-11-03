
import 'package:flutter/material.dart';
import '../../../meal_tracking/presentation/addmeal/widgets/architecture_cards.dart';
import '../../../meal_tracking/presentation/addmeal/widgets/top_header_bar.dart';
import '../cubit/dashboard_state.dart';
import 'dashboard_desktop_layout.dart';
import 'dashboard_mobile_layout.dart';

class DashboardContentLayout extends StatelessWidget {
  const DashboardContentLayout({
    super.key,
    required this.state,
    required this.userId,
    required this.isDesktop,
  });

  final DashboardLoaded state;
  final String userId;
  final bool isDesktop;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TopHeaderBar(),
        const SizedBox(height: 16),
        if (isDesktop)
          DashboardDesktopLayout(
            state: state,
            userId: userId,
          )
        else
          DashboardMobileLayout(
            state: state,
            userId: userId,
          ),
        const SizedBox(height: 20),
        const ArchitectureCards(),
      ],
    );
  }
}
