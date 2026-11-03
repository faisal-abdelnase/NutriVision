import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/daily_nutrition_summary.dart';
import '../../domain/entities/recent_meal_summary.dart';
import '../cubit/dashboard_cubit.dart';
import '../../../meal_tracking/presentation/addmeal/screens/add_meal_screen.dart';
import '../../../meal_tracking/presentation/meal_details/screens/meal_details_screen.dart';

class TodaysMealsCard extends StatelessWidget {
  const TodaysMealsCard({
    super.key,
    required this.summary,
    required this.meals,
    required this.userId,
  });

  final DailyNutritionSummary summary;
  final List<RecentMealSummary> meals;
  final String userId;

  @override
  Widget build(BuildContext context) => Card(
    color: AppColors.cardBg,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
      side: const BorderSide(color: AppColors.border),
    ),
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Recent Meals',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
              ),
              Text(
                '${summary.mealCount} today',
                style: const TextStyle(
                  fontSize: 10,
                  color: AppColors.mutedText,
                ),
              ),
              TextButton.icon(
                onPressed: () => _add(context),
                icon: const Icon(Icons.add, size: 14),
                label: const Text('Add Meal'),
              ),
            ],
          ),
          if (meals.isEmpty) ...[
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Center(
                child: Text(
                  'No meals logged yet today.',
                  style: TextStyle(color: AppColors.mutedText),
                ),
              ),
            ),
            Center(
              child: OutlinedButton.icon(
                onPressed: () => _add(context),
                icon: const Icon(Icons.add),
                label: const Text('Add your first meal'),
              ),
            ),
          ] else ...[
            for (final meal in meals)
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const CircleAvatar(
                  backgroundColor: Color(0xFFE0F2FE),
                  child: Icon(Icons.restaurant, color: AppColors.primaryTeal),
                ),
                title: Text(
                  meal.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Text(_time(meal.eatenAt)),
                trailing: Text('${meal.calories.round()} kcal'),
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => MealDetailsScreen(
                      mealName: meal.name,
                      calories: meal.calories,
                      eatenAt: meal.eatenAt,
                    ),
                  ),
                ),
              ),
          ],
        ],
      ),
    ),
  );

  Future<void> _add(BuildContext context) async {
    await Navigator.of(context).push<void>(
      MaterialPageRoute<void>(builder: (_) => const AddMealScreen()),
    );
    if (context.mounted)
      await context.read<DashboardCubit>().refreshDashboard(userId: userId);
  }

  String _time(DateTime date) {
    final local = date.toLocal();
    final hour = local.hour % 12 == 0 ? 12 : local.hour % 12;
    final minute = local.minute.toString().padLeft(2, '0');
    return '${local.year}-${local.month.toString().padLeft(2, '0')}-${local.day.toString().padLeft(2, '0')}  $hour:$minute ${local.hour < 12 ? 'AM' : 'PM'}';
  }
}
