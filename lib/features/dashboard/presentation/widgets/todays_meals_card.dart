import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../meal_tracking/presentation/addmeal/screens/add_meal_screen.dart';
import '../../../meal_tracking/presentation/meal_details/screens/meal_details_screen.dart';


class TodaysMealsCard extends StatelessWidget {
  const TodaysMealsCard({Key? key}) : super(key: key);

  void _navigateToAddMeal(BuildContext context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const AddMealScreen(),
        settings: const RouteSettings(name: '/add-meal'),
      ),
    );
  }

  void _navigateToMealDetails(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const MealDetailsScreen(),
        settings: const RouteSettings(name: '/meal-details'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Text("Today's Meals", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(color: const Color(0xFFDCFCE7), borderRadius: BorderRadius.circular(10)),
                    child: const Text('3 of 4 logged', style: TextStyle(fontSize: 9, color: Color(0xFF166534), fontWeight: FontWeight.bold)),
                  )
                ],
              ),
              TextButton.icon(
                onPressed: () => _navigateToAddMeal(context),
                icon: const Icon(Icons.add, size: 14, color: AppColors.primaryTeal),
                label: const Text('Add Meal', style: TextStyle(fontSize: 11, color: AppColors.primaryTeal, fontWeight: FontWeight.bold)),
              )
            ],
          ),
          const SizedBox(height: 12),

          // Meal 1: Breakfast
          _buildMealItem(
            context,
            'BREAKFAST • 08:30 AM',
            'Avocado & Poached Egg Sourdough Toast',
            'Multiseed rustic bread, organic Hass avocado, cage-free poached eggs.',
            '420 kcal',
            'P: 22g • C: 34g • F: 18g',
            'High Choline & Potassium',
            'https://images.unsplash.com/photo-1525351484163-7529414344d8',
          ),
          const SizedBox(height: 12),

          // Meal 2: Lunch
          _buildMealItem(
            context,
            'LUNCH • 01:15 PM',
            'Grilled Herb Salmon & Quinoa Bowl',
            'Wild Alaskan salmon, sprouted quinoa, steamed tenderstem broccoli.',
            '620 kcal',
            'P: 48g • C: 52g • F: 22g',
            'Omega-3 EPA/DHA Rich',
            'https://images.unsplash.com/photo-1546069901-ba9599a7e63c',
          ),
          const SizedBox(height: 12),

          // Meal 3: Snack
          _buildMealItem(
            context,
            'SNACK • 04:45 PM',
            'Greek Yogurt with Berries & Chia',
            '2% Grass-fed yogurt, antioxidant berry blend, black chia seeds.',
            '180 kcal',
            'P: 18g • C: 14g • F: 4g',
            'Probiotic Active Microflora',
            'https://images.unsplash.com/photo-1488477181946-6428a0291777',
          ),
          const SizedBox(height: 12),

          // Meal 4: Dinner (Not logged yet)
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border, style: BorderStyle.solid),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.restaurant, size: 14, color: AppColors.mutedText),
                        SizedBox(width: 6),
                        Text('DINNER • PLANNED SLOT', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.mutedText)),
                      ],
                    ),
                    const Text('~680 target kcal', style: TextStyle(fontSize: 10, color: AppColors.mutedText)),
                  ],
                ),
                const SizedBox(height: 6),
                const Text('Dinner not logged yet', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.darkText)),
                const Text('Suggested: Lean Herb Chicken Breast or Garlic Edamame Stir-fry.', style: TextStyle(fontSize: 10, color: AppColors.mutedText)),
                const SizedBox(height: 10),
                LayoutBuilder(
                  builder: (context, constraints) {
                    if (constraints.maxWidth < 350) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('+45g Protein required to hit today\'s target', style: TextStyle(fontSize: 9, color: Color(0xFFC2410C), fontWeight: FontWeight.w600)),
                          const SizedBox(height: 8),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: () => _navigateToAddMeal(context),
                              icon: const Icon(Icons.crop_free, size: 12),
                              label: const Text('Scan with Vision AI', style: TextStyle(fontSize: 10)),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primaryTeal,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 8),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                              ),
                            ),
                          )
                        ],
                      );
                    }
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Expanded(
                          child: Text('+45g Protein required to hit today\'s target', style: TextStyle(fontSize: 9, color: Color(0xFFC2410C), fontWeight: FontWeight.w600)),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton.icon(
                          onPressed: () => _navigateToAddMeal(context),
                          icon: const Icon(Icons.crop_free, size: 12),
                          label: const Text('Scan with Vision AI', style: TextStyle(fontSize: 10)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryTeal,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                          ),
                        )
                      ],
                    );
                  },
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildMealItem(BuildContext context, String slot, String title, String description, String calories, String macros, String tag, String imageUrl) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _navigateToMealDetails(context),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  imageUrl,
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                  errorBuilder: (c, e, s) => Container(
                    width: 50,
                    height: 50,
                    color: Colors.grey.shade300,
                    child: const Icon(Icons.fastfood, size: 20),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            slot,
                            style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: AppColors.mutedText),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(calories, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.darkText)),
                      ],
                    ),
                    Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12), maxLines: 1, overflow: TextOverflow.ellipsis),
                    Text(description, style: const TextStyle(fontSize: 9, color: AppColors.mutedText), maxLines: 1, overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(macros, style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w600, color: AppColors.darkText), overflow: TextOverflow.ellipsis),
                        ),
                        const SizedBox(width: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(color: const Color(0xFFE0F2FE), borderRadius: BorderRadius.circular(4)),
                          child: Text(tag, style: const TextStyle(fontSize: 8, color: Color(0xFF0369A1), fontWeight: FontWeight.bold)),
                        )
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}