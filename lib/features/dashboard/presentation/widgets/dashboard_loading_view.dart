
import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class DashboardLoadingView extends StatelessWidget {
  const DashboardLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(
        color: AppColors.primaryTeal,
      ),
    );
  }
}
