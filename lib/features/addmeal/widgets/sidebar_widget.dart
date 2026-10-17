import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../dashboard/screens/dashboard_screen.dart';
import '../../your progress/screens/progress_screen.dart';
import '../screens/add_meal_screen.dart';


class SidebarWidget extends StatelessWidget {
  const SidebarWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String? currentRoute = ModalRoute.of(context)?.settings.name;

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
                      color: AppColors.primaryTeal.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.blur_on, color: AppColors.primaryTeal, size: 24),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text('NutriVision', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      Text('CLINICAL INTEL', style: TextStyle(color: AppColors.primaryTeal, fontSize: 10, fontWeight: FontWeight.bold)),
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
            Container(
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
                      children: const [
                        Text('Dr. E. Vance', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                        Text('Lead Dietitian', style: TextStyle(color: AppColors.mutedText, fontSize: 10)),
                      ],
                    ),
                  ),
                  const Icon(Icons.verified_outlined, size: 16, color: AppColors.mutedText),
                ],
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
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFF00B074) : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        dense: true,
        leading: Icon(icon, color: isSelected ? Colors.white : AppColors.mutedText, size: 20),
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
    );
  }
}