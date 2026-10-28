import 'package:flutter/material.dart';
import '../../../../core/theme/theme_colors.dart';
import '../../../../core/theme/theme_dimensions.dart';
import '../../../../core/theme/theme_extensions.dart';

class FoodDislikesSelector extends StatefulWidget {
  const FoodDislikesSelector({
    super.key,
    required this.selectedDislikes,
    required this.onToggleDislike,
    required this.surfaces,
    required this.isDark,
    required this.isRtl,
  });

  final Set<String> selectedDislikes;
  final ValueChanged<String> onToggleDislike;
  final AppSurfaceColors surfaces;
  final bool isDark;
  final bool isRtl;

  @override
  State<FoodDislikesSelector> createState() => _FoodDislikesSelectorState();
}

class _FoodDislikesSelectorState extends State<FoodDislikesSelector> {
  final TextEditingController _dislikeSearchCtrl = TextEditingController();

  @override
  void dispose() {
    _dislikeSearchCtrl.dispose();
    super.dispose();
  }

  void _handleSubmit(String val) {
    if (val.trim().isNotEmpty) {
      widget.onToggleDislike(val.trim());
      _dislikeSearchCtrl.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final cardBg = widget.isDark
        ? ThemeColors.darkSurface1
        : ThemeColors.stitchSurfaceContainerLowest;
    final border = widget.isDark
        ? ThemeColors.darkBorder
        : ThemeColors.slate200;

    final allDislikes = widget.isRtl
        ? [
            'الكزبرة',
            'الفطر / المشروم',
            'المحليات الصناعية',
            'لحم الخنزير',
            'الأكل الحار / الشطة',
            'اللحوم الحمراء',
            'السكر المكرر المضاف',
            'الباذنجان',
          ]
        : [
            'Cilantro / الكزبرة',
            'Mushrooms / الفطر',
            'Artificial Sweeteners / المحليات الصناعية',
            'Pork / لحم الخنزير',
            'Spicy Food / الأكل الحار',
            'Red Meat / اللحوم الحمراء',
            'Added Refined Sugar / السكر المضاف',
            'Eggplant / الباذنجان',
          ];

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
                  color: widget.isDark
                      ? ThemeColors.darkSurface2
                      : ThemeColors.stitchSurfaceContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Icon(
                    Icons.thumb_down_off_alt_rounded,
                    color: widget.surfaces.textPrimary,
                    size: 20,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.isRtl
                          ? 'القسم ج: تفضيلات الطعم والمكونات غير المفضلة'
                          : 'Section C: Food Dislikes & Sensory Avoidance',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: widget.surfaces.textPrimary,
                      ),
                    ),
                    Text(
                      widget.isRtl
                          ? 'مكونات لا تفضلها • استبعاد تلقائي ذكي بالذكاء الاصطناعي'
                          : 'تفضيلات الطعم ومكونات لا تفضلها • AI soft deprioritization',
                      style: TextStyle(
                        fontSize: 11,
                        color: widget.surfaces.textSecondary,
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
                  color: widget.isDark
                      ? ThemeColors.darkSurface2
                      : ThemeColors.stitchSurfaceContainer,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  widget.isRtl ? 'اختياري' : 'Optional',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: widget.surfaces.textSecondary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: allDislikes.map((dislike) {
              final isSelected = widget.selectedDislikes.contains(dislike);
              return InkWell(
                onTap: () => widget.onToggleDislike(dislike),
                borderRadius: BorderRadius.circular(999),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? (widget.isDark
                              ? ThemeColors.stitchSecondaryDark
                              : ThemeColors.stitchSecondaryFixed)
                        : (widget.isDark
                              ? ThemeColors.darkSurface2
                              : ThemeColors.stitchSurfaceContainerLow),
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(
                      color: isSelected ? ThemeColors.stitchSecondary : border,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        dislike,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.w500,
                          color: isSelected
                              ? (widget.isDark
                                    ? Colors.black
                                    : ThemeColors.slate900)
                              : widget.surfaces.textPrimary,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Icon(
                        isSelected ? Icons.check : Icons.add,
                        size: 14,
                        color: isSelected
                            ? ThemeColors.stitchPrimary
                            : widget.surfaces.textMuted,
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 12),

          Container(
            height: 40,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: widget.isDark
                  ? ThemeColors.darkSurface2
                  : ThemeColors.stitchSurfaceContainerLow,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: border),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.search_rounded,
                  size: 18,
                  color: widget.surfaces.textMuted,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _dislikeSearchCtrl,
                    style: TextStyle(
                      fontSize: 12.5,
                      color: widget.surfaces.textPrimary,
                    ),
                    decoration: InputDecoration(
                      hintText: widget.isRtl
                          ? 'اكتب مكوناً ترغب في استبعاده (مثل: الفلفل الرومي، الزيتون، جبن الماعز)...'
                          : 'Type ingredient to exclude (e.g., Bell peppers, Olives, Goat cheese)...',
                      hintStyle: TextStyle(
                        fontSize: 11.5,
                        color: widget.surfaces.placeholder,
                      ),
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                    ),
                    onSubmitted: _handleSubmit,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
