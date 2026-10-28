import 'package:flutter/material.dart';
import '../../../../core/theme/theme_colors.dart';
import '../../../../core/theme/theme_dimensions.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../models/info_completion_state.dart';

class DietaryRegimenSelector extends StatelessWidget {
  const DietaryRegimenSelector({
    super.key,
    required this.selectedRegimen,
    required this.onRegimenChanged,
    required this.surfaces,
    required this.isDark,
    required this.isRtl,
  });

  final DietaryRegimenType selectedRegimen;
  final ValueChanged<DietaryRegimenType> onRegimenChanged;
  final AppSurfaceColors surfaces;
  final bool isDark;
  final bool isRtl;

  @override
  Widget build(BuildContext context) {
    final cardBg = isDark
        ? ThemeColors.darkSurface1
        : ThemeColors.stitchSurfaceContainerLowest;
    final border = isDark ? ThemeColors.darkBorder : ThemeColors.slate200;

    return Container(
      padding: const EdgeInsets.all(ThemeDimensions.spaceLg),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: ThemeColors.stitchPrimaryFixed,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Center(
                  child: Icon(
                    Icons.restaurant_menu_rounded,
                    color: ThemeColors.stitchOnPrimaryFixed,
                    size: 22,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isRtl
                          ? 'القسم أ: النمط الغذائي الرئيسي'
                          : 'Section A: Core Dietary Regimen',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: surfaces.textPrimary,
                      ),
                    ),
                    Text(
                      isRtl
                          ? 'النسب الأساسية للمغذيات • خط البداية الشامل'
                          : 'النمط الغذائي الرئيسي • Foundational macro ratios',
                      style: TextStyle(
                        fontSize: 11,
                        color: surfaces.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: isDark
                      ? ThemeColors.darkSurface2
                      : ThemeColors.stitchSurfaceContainer,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  isRtl ? 'اختيار أحادي' : 'Single Selection',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: surfaces.textSecondary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth >= 600;
              final regimens = [
                _buildRegimenCard(
                  type: DietaryRegimenType.standard,
                  title: isRtl ? 'بدون تفضيل محدد' : 'No Preference',
                  subtitle: isRtl
                      ? 'متوازن قياسي'
                      : 'Standard Balanced • متوازن',
                  description: isRtl
                      ? 'نمط غذائي شامل ومرن يغطي كافة الاحتياجات اليومية من المغذيات.'
                      : 'Flexible omnivorous baseline with balanced micro/macro intake.',
                  icon: Icons.balance_rounded,
                  iconColor: const Color(0xFF006398),
                  isSelected: selectedRegimen == DietaryRegimenType.standard,
                ),
                _buildRegimenCard(
                  type: DietaryRegimenType.highProtein,
                  title: isRtl ? 'عالي البروتين' : 'High Protein',
                  tag: isRtl ? 'الأمثل' : 'Optimal',
                  subtitle: isRtl
                      ? 'تركيز على الأحماض الأمينية النقية'
                      : 'عالي البروتين • Lean Amino Focus',
                  description: isRtl
                      ? 'مستهدف 1.8-2.2 غ/كغ من الدواجن الخالية من الدهون والأسماك والتوفو والمكملات.'
                      : '1.8-2.2g/kg targets with lean poultry, fish, tofu, or isolates.',
                  icon: Icons.fitness_center_rounded,
                  iconColor: ThemeColors.stitchPrimary,
                  isSelected: selectedRegimen == DietaryRegimenType.highProtein,
                ),
                _buildRegimenCard(
                  type: DietaryRegimenType.mediterranean,
                  title: isRtl ? 'حمية البحر المتوسط' : 'Mediterranean',
                  subtitle: isRtl
                      ? 'غنية بمضادات الأكسدة وزيت الزيتون'
                      : 'حمية البحر الأبيض المتوسط',
                  description: isRtl
                      ? 'تركيز على زيت الزيتون البكر، الخضار الورقية، الحبوب الكاملة، والأوميغا-3.'
                      : 'High polyphenol olive oil, greens, whole grains, and omega-3s.',
                  icon: Icons.eco_rounded,
                  iconColor: const Color(0xFF9D4300),
                  isSelected:
                      selectedRegimen == DietaryRegimenType.mediterranean,
                ),
                _buildRegimenCard(
                  type: DietaryRegimenType.lowCarb,
                  title: isRtl ? 'منخفض الكربوهيدرات' : 'Low Carb',
                  subtitle: isRtl
                      ? 'كيتوجيني تكيفي'
                      : 'منخفض الكربوهيدرات • Ketogenic',
                  description: isRtl
                      ? 'ضبط منحنى السكر في الدم مع استقرار إفراز الإنسولين الأساسي.'
                      : 'Restricted glycemic curve with stabilized basal insulin thresholds.',
                  icon: Icons.bolt_rounded,
                  iconColor: const Color(0xFF006398),
                  isSelected: selectedRegimen == DietaryRegimenType.lowCarb,
                ),
                _buildRegimenCard(
                  type: DietaryRegimenType.vegetarian,
                  title: isRtl ? 'نباتي' : 'Vegetarian',
                  subtitle: isRtl
                      ? 'يسمح بالألبان والبيض'
                      : 'نباتي • Dairy/Eggs Allowed',
                  description: isRtl
                      ? 'نظام نباتي متوازن يحتفظ ببروتينات اللاكتو-أوفو عالية الامتصاص.'
                      : 'Plant-forward framework retaining lacto-ovo bioavailable proteins.',
                  icon: Icons.spa_rounded,
                  iconColor: ThemeColors.stitchPrimary,
                  isSelected: selectedRegimen == DietaryRegimenType.vegetarian,
                ),
                _buildRegimenCard(
                  type: DietaryRegimenType.vegan,
                  title: isRtl ? 'نباتي صِرف' : 'Vegan',
                  subtitle: isRtl
                      ? '100% نباتي خالي من المشتقات'
                      : 'نباتي صرف • 100% Plant',
                  description: isRtl
                      ? 'استبعاد كلي لجميع الأطعمة والمشتقات الحيوانية.'
                      : 'Strict exclusion of animal-derived foods and animal byproducts.',
                  icon: Icons.yard_rounded,
                  iconColor: ThemeColors.stitchPrimary,
                  isSelected: selectedRegimen == DietaryRegimenType.vegan,
                ),
              ];

              if (isWide) {
                return Column(
                  children: [
                    Row(
                      children: [
                        Expanded(child: regimens[0]),
                        const SizedBox(width: 10),
                        Expanded(child: regimens[1]),
                        const SizedBox(width: 10),
                        Expanded(child: regimens[2]),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(child: regimens[3]),
                        const SizedBox(width: 10),
                        Expanded(child: regimens[4]),
                        const SizedBox(width: 10),
                        Expanded(child: regimens[5]),
                      ],
                    ),
                  ],
                );
              } else {
                return Column(
                  children: regimens
                      .map(
                        (card) => Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: card,
                        ),
                      )
                      .toList(),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildRegimenCard({
    required DietaryRegimenType type,
    required String title,
    String? tag,
    required String subtitle,
    required String description,
    required IconData icon,
    required Color iconColor,
    required bool isSelected,
  }) {
    final border = isSelected
        ? ThemeColors.stitchPrimary
        : (isDark ? ThemeColors.darkBorder : ThemeColors.slate200);
    final bg = isSelected
        ? ThemeColors.stitchPrimaryFixed.withValues(alpha: isDark ? 0.2 : 0.25)
        : (isDark
              ? ThemeColors.darkSurface2
              : ThemeColors.stitchSurfaceContainerLow);

    return InkWell(
      onTap: () => onRegimenChanged(type),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: border, width: isSelected ? 1.5 : 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(icon, size: 22, color: iconColor),
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? ThemeColors.stitchPrimary
                        : (isDark
                              ? ThemeColors.darkSurface3
                              : ThemeColors.stitchSurfaceContainerHigh),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Icon(
                      Icons.check,
                      size: 13,
                      color: isSelected ? Colors.white : Colors.transparent,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 6,
              runSpacing: 4,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: isSelected
                        ? ThemeColors.stitchPrimary
                        : surfaces.textPrimary,
                  ),
                ),
                if (tag != null)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 5,
                      vertical: 1.5,
                    ),
                    decoration: BoxDecoration(
                      color: ThemeColors.stitchPrimary,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      tag.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 8.5,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 10.5,
                fontWeight: FontWeight.w500,
                color: surfaces.textSecondary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              description,
              style: TextStyle(
                fontSize: 11,
                color: surfaces.textMuted,
                height: 1.3,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
