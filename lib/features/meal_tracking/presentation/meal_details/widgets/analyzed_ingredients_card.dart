import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../nutrition_profile/domain/entities/nutrition_profile.dart';
import '../../../../nutrition_profile/presentation/cubit/nutrition_profile_cubit.dart';

class AnalyzedIngredientsCard extends StatelessWidget {
  const AnalyzedIngredientsCard({super.key});

  @override
  Widget build(BuildContext context) {
    final profile = context.watch<NutritionProfileCubit?>()?.currentProfile;
    final bool hasSeafoodAlert = profile?.containsAllergen('seafood') ?? false;

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
          // Wrap to prevent overflow on small screens
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 8,
            runSpacing: 6,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Analyzed Ingredients & Portions',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                  Text(
                    'المكونات والحصص الغذائية المحللة',
                    style: TextStyle(fontSize: 9, color: AppColors.mutedText),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: hasSeafoodAlert
                      ? const Color(0xFFFEE2E2)
                      : const Color(0xFFEFF6FF),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  hasSeafoodAlert
                      ? '⚠️ Allergen Detected'
                      : '4 Verified Components',
                  style: TextStyle(
                    fontSize: 8,
                    color: hasSeafoodAlert
                        ? const Color(0xFFDC2626)
                        : const Color(0xFF0369A1),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          if (hasSeafoodAlert) ...[
            Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFFFEF2F2),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFFCA5A5)),
              ),
              child: Row(
                children: const [
                  Icon(
                    Icons.warning_amber_rounded,
                    size: 16,
                    color: Color(0xFFDC2626),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'AI Clinical Warning: Sockeye Salmon conflicts with your registered Seafood Allergy! Consider using Smart Swaps below.',
                      style: TextStyle(
                        fontSize: 9,
                        color: Color(0xFF991B1B),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ] else if (profile != null && profile.allergies.isNotEmpty) ...[
            Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFF0FDF4),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFBBF7D0)),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.verified_user_outlined,
                    size: 14,
                    color: Color(0xFF15803D),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      'Allergen Safeguards Passed: Verified free from ${profile.allergies.join(", ")}.',
                      style: const TextStyle(
                        fontSize: 9,
                        color: Color(0xFF166534),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],

          _buildIngredientTile(
            Icons.set_meal,
            hasSeafoodAlert
                ? 'Wild Alaskan Sockeye Salmon (⚠️ ALLERGEN)'
                : 'Wild Alaskan Sockeye Salmon',
            'Rich EPA/DHA Omega-3 • 36g Protein',
            '180g',
            '370 kcal',
            hasSeafoodAlert ? const Color(0xFFFEE2E2) : Colors.green.shade100,
            hasSeafoodAlert ? const Color(0xFFDC2626) : AppColors.primaryTeal,
          ),
          _buildIngredientTile(
            Icons.grain,
            'Tri-Color Organic Quinoa',
            'Cooked • Complete 9 Essential Amino Acids',
            '120g',
            '144 kcal',
            Colors.blue.shade100,
            const Color(0xFF0284C7),
          ),
          _buildIngredientTile(
            Icons.grass,
            'Steamed Tenderstem Broccoli',
            'Sulforaphane, Vitamin K1 & Active Fiber',
            '60g',
            '21 kcal',
            Colors.green.shade100,
            AppColors.primaryTeal,
          ),
          _buildIngredientTile(
            Icons.water_drop,
            'Extra Virgin Olive Oil (EVOO)',
            'High Phenolic Oleocanthal & Oleic Acid',
            '10g',
            '85 kcal',
            Colors.orange.shade100,
            const Color(0xFFEA580C),
          ),

          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: () {},
            icon: const Icon(
              Icons.add_circle_outline,
              size: 14,
              color: AppColors.primaryTeal,
            ),
            label: const Text(
              '+ Add Extra Ingredient, Sauce or Dressing',
              style: TextStyle(
                fontSize: 10,
                color: AppColors.primaryTeal,
                fontWeight: FontWeight.bold,
              ),
              overflow: TextOverflow.ellipsis,
            ),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(double.infinity, 38),
              side: const BorderSide(color: AppColors.border),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIngredientTile(
    IconData icon,
    String title,
    String sub,
    String weight,
    String kcal,
    Color bgClr,
    Color iconClr,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: bgClr,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(icon, size: 16, color: iconClr),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  sub,
                  style: const TextStyle(
                    fontSize: 8,
                    color: AppColors.mutedText,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 6),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                weight,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 11,
                ),
              ),
              Text(
                kcal,
                style: const TextStyle(fontSize: 8, color: AppColors.mutedText),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
