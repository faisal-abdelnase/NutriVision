import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/routing/route_names.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../dashboard/presentation/screens/dashboard_screen.dart';
import '../../../../nutrition_profile/domain/entities/nutrition_profile.dart';
import '../../../../nutrition_profile/presentation/cubit/nutrition_profile_cubit.dart';
import '../../../../progress/presentation/screens/progress_screen.dart';
import '../screens/add_meal_screen.dart';

class SidebarWidget extends StatelessWidget {
  const SidebarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final String? currentRoute = ModalRoute.of(context)?.settings.name;
    final profile = context.watch<NutritionProfileCubit?>()?.currentProfile;

    return Material(
      color: AppColors.sidebarBackground,
      child: SizedBox(
        width: 240,
        child: Column(
          children: [
            // Header / Logo
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.primaryTeal.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.blur_on,
                      color: AppColors.primaryTeal,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'NutriVision',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        'CLINICAL INTEL',
                        style: TextStyle(
                          color: AppColors.primaryTeal,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Navigation Items
            _buildNavItem(
              context,
              Icons.dashboard_outlined,
              'Dashboard',
              isSelected: currentRoute == '/' || currentRoute == '/dashboard',
              onTap: () {
                if (currentRoute != '/dashboard') {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => const DashboardScreen(),
                      settings: const RouteSettings(name: '/dashboard'),
                    ),
                  );
                }
              },
            ),
            _buildNavItem(
              context,
              Icons.flatware_outlined,
              'Meal Scanner / Add Meal',
              isSelected: currentRoute == '/add-meal',
              onTap: () {
                if (currentRoute != '/add-meal') {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => const AddMealScreen(),
                      settings: const RouteSettings(name: '/add-meal'),
                    ),
                  );
                }
              },
            ),
            _buildNavItem(
              context,
              Icons.show_chart,
              'Your Progress / Biomarkers',
              isSelected: currentRoute == '/progress',
              onTap: () {
                if (currentRoute != '/progress') {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => const ProgressScreen(),
                      settings: const RouteSettings(name: '/progress'),
                    ),
                  );
                }
              },
            ),
            _buildNavItem(
              context,
              Icons.tune,
              'Calibration • المعايرة',
              isSelected: currentRoute == RouteNames.infoCompletion,
              onTap: () {
                Navigator.of(context).pushNamed(RouteNames.infoCompletion);
              },
            ),
            _buildNavItem(
              context,
              Icons.restaurant_menu,
              'Nutrition Log',
              isSelected: false,
              onTap: () {},
            ),
            _buildNavItem(
              context,
              Icons.auto_awesome_outlined,
              'AI Meal Planner',
              isSelected: false,
              onTap: () {},
            ),
            _buildNavItem(
              context,
              Icons.settings_outlined,
              'Settings',
              isSelected: false,
              onTap: () {},
            ),

            const Spacer(),

            // Footer
            InkWell(
              onTap: () {
                Navigator.of(context).pushNamed(RouteNames.infoCompletion);
              },
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const CircleAvatar(
                      backgroundColor: AppColors.primaryTeal,
                      radius: 16,
                      child: Icon(Icons.person, color: Colors.white, size: 18),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            profile != null && profile.isCalibrated
                                ? '${profile.weightKg}kg • ${profile.goalLabelEn}'
                                : 'Dr. E. Vance',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 11,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            profile != null && profile.isCalibrated
                                ? '${profile.regimenLabelEn} Regimen'
                                : 'Lead Dietitian',
                            style: const TextStyle(
                              color: AppColors.mutedText,
                              fontSize: 9,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.tune,
                      size: 14,
                      color: AppColors.primaryTeal,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context,
    IconData icon,
    String label, {
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Material(
        color: isSelected ? const Color(0xFF00B074) : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        clipBehavior: Clip.antiAlias,
        child: ListTile(
          dense: true,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          leading: Icon(
            icon,
            color: isSelected ? Colors.white : AppColors.mutedText,
            size: 20,
          ),
          title: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : AppColors.darkText,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              fontSize: 13,
            ),
          ),
          onTap: onTap,
        ),
      ),
    );
  }
}
