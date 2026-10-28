import 'package:flutter/material.dart';
import '../../../../core/theme/theme_colors.dart';
import '../../../../core/theme/theme_dimensions.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../models/info_completion_state.dart';

class GoalSelectionCard extends StatelessWidget {
  const GoalSelectionCard({
    super.key,
    required this.goalType,
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.tag,
    required this.title,
    required this.description,
    required this.targetPace,
    required this.energyModel,
    required this.isSelected,
    required this.isDark,
    required this.surfaces,
    required this.onTap,
    this.isRtl = false,
  });

  final DietaryGoalType goalType;
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String tag;
  final String title;
  final String description;
  final String targetPace;
  final String energyModel;
  final bool isSelected;
  final bool isDark;
  final AppSurfaceColors surfaces;
  final VoidCallback onTap;
  final bool isRtl;

  @override
  Widget build(BuildContext context) {
    final border = isSelected
        ? ThemeColors.stitchPrimary
        : (isDark ? ThemeColors.darkBorder : ThemeColors.slate200);
    final bg = isSelected
        ? (isDark
              ? ThemeColors.darkSurface1
              : ThemeColors.stitchSurfaceContainerLowest)
        : (isDark
              ? ThemeColors.darkSurface2
              : ThemeColors.stitchSurfaceContainerLow);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(ThemeDimensions.spaceMd),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: border, width: isSelected ? 2 : 1),
          boxShadow: isSelected && !isDark
              ? const [
                  BoxShadow(
                    color: Color(0x14006C49),
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: iconBg,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(child: Icon(icon, color: iconColor, size: 24)),
                ),
                Container(
                  width: 26,
                  height: 26,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? ThemeColors.stitchPrimary
                        : (isDark
                              ? ThemeColors.darkSurface3
                              : ThemeColors.stitchSurfaceContainerHighest),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Icon(
                      Icons.check_rounded,
                      size: 16,
                      color: isSelected ? Colors.white : Colors.transparent,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: isDark
                    ? ThemeColors.darkSurface3
                    : ThemeColors.stitchSurfaceContainerHigh,
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                tag,
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: ThemeColors.stitchPrimary,
                ),
              ),
            ),
            const SizedBox(height: 8),

            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: surfaces.textPrimary,
              ),
            ),
            const SizedBox(height: 6),

            Text(
              description,
              style: TextStyle(
                fontSize: 12,
                height: 1.4,
                color: surfaces.textSecondary,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 14),

            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isDark
                    ? ThemeColors.darkCanvas
                    : ThemeColors.stitchSurfaceContainerLow,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  Wrap(
                    alignment: WrapAlignment.spaceBetween,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 4,
                    runSpacing: 2,
                    children: [
                      Text(
                        isRtl ? 'المعدل المستهدف:' : 'Target Pace:',
                        style: const TextStyle(
                          fontSize: 11,
                          color: ThemeColors.slate500,
                        ),
                      ),
                      Text(
                        targetPace,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: ThemeColors.stitchPrimary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Wrap(
                    alignment: WrapAlignment.spaceBetween,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 4,
                    runSpacing: 2,
                    children: [
                      Text(
                        isRtl ? 'نموذج الطاقة:' : 'Energy Model:',
                        style: const TextStyle(
                          fontSize: 11,
                          color: ThemeColors.slate500,
                        ),
                      ),
                      Text(
                        energyModel,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: surfaces.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            if (isSelected) ...[
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 4),
                decoration: BoxDecoration(
                  color: ThemeColors.stitchPrimary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.verified_rounded,
                      size: 13,
                      color: ThemeColors.stitchPrimary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      isRtl ? 'الهدف الأساسي المختار' : 'Selected Primary Goal',
                      style: const TextStyle(
                        fontSize: 10.5,
                        fontWeight: FontWeight.bold,
                        color: ThemeColors.stitchPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
