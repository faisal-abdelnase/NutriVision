import 'package:flutter/material.dart';
import '../../../../core/theme/theme_colors.dart';
import '../../../../core/theme/theme_dimensions.dart';
import '../../../../core/theme/theme_extensions.dart';

class AllergensSafeguardSelector extends StatefulWidget {
  const AllergensSafeguardSelector({
    super.key,
    required this.selectedAllergens,
    required this.customAllergens,
    required this.onToggleAllergen,
    required this.onAddCustomAllergen,
    required this.onRemoveCustomAllergen,
    required this.surfaces,
    required this.isDark,
    required this.isRtl,
  });

  final Set<String> selectedAllergens;
  final List<String> customAllergens;
  final ValueChanged<String> onToggleAllergen;
  final ValueChanged<String> onAddCustomAllergen;
  final ValueChanged<String> onRemoveCustomAllergen;
  final AppSurfaceColors surfaces;
  final bool isDark;
  final bool isRtl;

  @override
  State<AllergensSafeguardSelector> createState() =>
      _AllergensSafeguardSelectorState();
}

class _AllergensSafeguardSelectorState
    extends State<AllergensSafeguardSelector> {
  final TextEditingController _customAllergenCtrl = TextEditingController();

  @override
  void dispose() {
    _customAllergenCtrl.dispose();
    super.dispose();
  }

  void _handleAdd() {
    final text = _customAllergenCtrl.text.trim();
    if (text.isNotEmpty) {
      widget.onAddCustomAllergen(text);
      _customAllergenCtrl.clear();
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

    final totalExclusions =
        widget.selectedAllergens.length + widget.customAllergens.length;

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
          Container(
            padding: const EdgeInsets.all(ThemeDimensions.spaceMd),
            decoration: BoxDecoration(
              color: widget.isDark
                  ? ThemeColors.errorContainerDark.withValues(alpha: 0.35)
                  : ThemeColors.errorContainer.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: widget.isDark
                    ? ThemeColors.errorDark.withValues(alpha: 0.4)
                    : ThemeColors.error.withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: const BoxDecoration(
                    color: ThemeColors.error,
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.health_and_safety_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              widget.isRtl
                                  ? 'سيتم مراعاة موانع الحساسية بدقة متناهية عند إنشاء التوصيات الذكية'
                                  : 'Your allergies will be strictly considered when generating AI recommendations',
                              style: TextStyle(
                                fontSize: 13.5,
                                fontWeight: FontWeight.bold,
                                color: widget.isDark
                                    ? ThemeColors.errorDark
                                    : ThemeColors.error,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: ThemeColors.error,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              widget.isRtl
                                  ? 'انعدام التسامح'
                                  : 'ZERO TOLERANCE',
                              style: const TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 3),
                      Text(
                        widget.isRtl
                            ? 'سيتم أخذ الحساسية الغذائية في الاعتبار بدقة طبية عند إنشاء كافة اقتراحات الوجبات والبدائل الذكية.'
                            : 'Food allergies will be rigorously accounted for in all generated meal plans and smart swaps.',
                        style: TextStyle(
                          fontSize: 11,
                          color: widget.isDark
                              ? ThemeColors.onErrorContainerDark
                              : ThemeColors.onErrorContainer,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.isRtl
                            ? 'حاجز الحماية السريري نشط: يقوم التعرف البصري الفوري للأطعمة بالتحذير تلقائياً من التلوث التبادلي المحتمل والصلصات الخفية والمشتقات المسببة للحساسية.'
                            : 'Clinical Guardrail Active: Real-time Computer Vision food recognition will automatically flag potential cross-contact, hidden sauces, and common derivative allergens with high-fidelity visual telemetry.',
                        style: TextStyle(
                          fontSize: 11.5,
                          height: 1.35,
                          color: widget.surfaces.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 12,
            runSpacing: 8,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.isRtl
                        ? 'القسم ب: موانع الحساسية والاضطرابات الهضمية'
                        : 'Section B: Medical Allergens & Celiac Flags',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: widget.surfaces.textPrimary,
                    ),
                  ),
                  Text(
                    widget.isRtl
                        ? 'موانع الحساسية والسيلياك • قواعد استبعاد متعددة الخيارات'
                        : 'موانع الحساسية والاضطرابات الهضمية • Multi-select exclusion rules',
                    style: TextStyle(
                      fontSize: 11,
                      color: widget.surfaces.textSecondary,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.warning_amber_rounded,
                    size: 16,
                    color: ThemeColors.error,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    widget.isRtl
                        ? 'الموانع النشطة: $totalExclusions محددة'
                        : 'ACTIVE EXCLUSIONS: $totalExclusions SELECTED',
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: ThemeColors.error,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 14),

          LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth >= 600;
              final allergenCards = [
                _buildAllergenItem(
                  key: 'peanuts',
                  title: widget.isRtl ? 'الفول السوداني' : 'Peanuts',
                  subtitle: widget.isRtl
                      ? 'خطر الصدمة التأقية'
                      : 'الفول السوداني',
                  badge: widget.isRtl ? 'إنذار تأقي حرج' : 'Anaphylaxis Alert',
                  icon: Icons.emergency_rounded,
                  isHighRisk: true,
                ),
                _buildAllergenItem(
                  key: 'seafood',
                  title: widget.isRtl
                      ? 'المأكولات البحرية'
                      : 'Seafood & Shellfish',
                  subtitle: widget.isRtl
                      ? 'حساسية تنفسية شديدة'
                      : 'المأكولات البحرية',
                  badge: widget.isRtl ? 'شديدة الخطورة' : 'High Severity',
                  icon: Icons.set_meal_rounded,
                  isHighRisk: true,
                ),
                _buildAllergenItem(
                  key: 'dairy',
                  title: widget.isRtl ? 'الحليب ومشتقاته' : 'Milk / Dairy',
                  subtitle: widget.isRtl
                      ? 'اللاكتوز ومصل اللبن'
                      : 'الحليب ومشتقاته',
                  badge: widget.isRtl ? 'لاكتوز / واي' : 'Lactose / Whey',
                  icon: Icons.water_drop_rounded,
                ),
                _buildAllergenItem(
                  key: 'eggs',
                  title: widget.isRtl ? 'البيض' : 'Eggs',
                  subtitle: widget.isRtl ? 'الألبومين والصفار' : 'البيض',
                  badge: widget.isRtl ? 'ألبومين / صفار' : 'Albumin / Yolk',
                  icon: Icons.egg_rounded,
                ),
                _buildAllergenItem(
                  key: 'gluten',
                  title: widget.isRtl
                      ? 'الجلوتين وحساسية القمح'
                      : 'Gluten / Celiac',
                  subtitle: widget.isRtl
                      ? 'القمح والشعير والجاودار'
                      : 'الجلوتين',
                  badge: widget.isRtl
                      ? 'قمح، شعير، حبوب'
                      : 'Wheat, Barley, Rye',
                  icon: Icons.grain_rounded,
                ),
                _buildAllergenItem(
                  key: 'soy',
                  title: widget.isRtl ? 'الصويا ومشتقاتها' : 'Soy',
                  subtitle: widget.isRtl
                      ? 'ليسيثين الصويا والتوفو'
                      : 'الصويا ومشتقاتها',
                  badge: widget.isRtl ? 'ليسيثين الصويا' : 'Soy Lecithin, Tofu',
                  icon: Icons.energy_savings_leaf_rounded,
                ),
                _buildAllergenItem(
                  key: 'tree_nuts',
                  title: widget.isRtl ? 'المكسرات الشجرية' : 'Tree Nuts',
                  subtitle: widget.isRtl
                      ? 'اللوز، الجوز، الكاجو'
                      : 'المكسرات الشجرية',
                  badge: widget.isRtl ? 'لوز وجوز وكاجو' : 'Almonds, Walnuts',
                  icon: Icons.spa_rounded,
                ),
                _buildAllergenItem(
                  key: 'sesame',
                  title: widget.isRtl ? 'السمسم والطحينة' : 'Sesame',
                  subtitle: widget.isRtl
                      ? 'معجون السمسم والزيوت'
                      : 'السمسم والطحينة',
                  badge: widget.isRtl ? 'طحينة وزيوت' : 'Tahini, Paste',
                  icon: Icons.filter_vintage_rounded,
                ),
              ];

              if (isWide) {
                return Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: allergenCards
                      .map(
                        (c) => SizedBox(
                          width: (constraints.maxWidth - 30) / 4,
                          child: c,
                        ),
                      )
                      .toList(),
                );
              } else {
                return Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: allergenCards
                      .map(
                        (c) => SizedBox(
                          width: (constraints.maxWidth - 10) / 2,
                          child: c,
                        ),
                      )
                      .toList(),
                );
              }
            },
          ),
          const SizedBox(height: 16),

          Text(
            widget.isRtl
                ? '+ أضف مسببات حساسية أخرى أو موانع طبية شديدة'
                : '+ Add other specific allergy or severe intolerance',
            style: TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.bold,
              color: widget.surfaces.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 44,
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
                        Icons.add_circle_outline_rounded,
                        size: 18,
                        color: widget.surfaces.textMuted,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          controller: _customAllergenCtrl,
                          style: TextStyle(
                            fontSize: 13,
                            color: widget.surfaces.textPrimary,
                          ),
                          decoration: InputDecoration(
                            hintText: widget.isRtl
                                ? 'اكتب المكون المسبب للحساسية (مثل: الخردل، الكبريتات، الترمس)...'
                                : 'Type allergen (e.g., Mustard, Lupine, Sulfites)...',
                            hintStyle: TextStyle(
                              fontSize: 12,
                              color: widget.surfaces.placeholder,
                            ),
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding: EdgeInsets.zero,
                          ),
                          onSubmitted: (_) => _handleAdd(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              FilledButton.icon(
                onPressed: _handleAdd,
                icon: const Icon(Icons.add, size: 16),
                label: Text(widget.isRtl ? 'إضافة استثناء' : 'Add Exclusion'),
                style: FilledButton.styleFrom(
                  backgroundColor: ThemeColors.stitchSecondary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
                ),
              ),
            ],
          ),

          if (widget.customAllergens.isNotEmpty) ...[
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 6,
              children: widget.customAllergens.map((allergen) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: ThemeColors.errorContainer.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(
                      color: ThemeColors.error.withValues(alpha: 0.4),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        allergen,
                        style: const TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.bold,
                          color: ThemeColors.error,
                        ),
                      ),
                      const SizedBox(width: 6),
                      InkWell(
                        onTap: () => widget.onRemoveCustomAllergen(allergen),
                        child: const Icon(
                          Icons.close_rounded,
                          size: 14,
                          color: ThemeColors.error,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildAllergenItem({
    required String key,
    required String title,
    required String subtitle,
    required String badge,
    required IconData icon,
    bool isHighRisk = false,
  }) {
    final isSelected = widget.selectedAllergens.contains(key);

    Color bg;
    Color border;
    Color textColor;
    Color iconColor;

    if (isSelected) {
      bg = widget.isDark
          ? ThemeColors.errorContainerDark.withValues(alpha: 0.4)
          : ThemeColors.errorContainer.withValues(alpha: 0.35);
      border = widget.isDark ? ThemeColors.errorDark : ThemeColors.error;
      textColor = widget.isDark ? ThemeColors.errorDark : ThemeColors.error;
      iconColor = widget.isDark ? ThemeColors.errorDark : ThemeColors.error;
    } else {
      bg = widget.isDark
          ? ThemeColors.darkSurface2
          : ThemeColors.stitchSurfaceContainerLow;
      border = widget.isDark ? ThemeColors.darkBorder : ThemeColors.slate200;
      textColor = widget.surfaces.textPrimary;
      iconColor = widget.isDark ? ThemeColors.slate400 : ThemeColors.slate600;
    }

    return InkWell(
      onTap: () => widget.onToggleAllergen(key),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(10),
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
                Icon(icon, size: 20, color: iconColor),
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? ThemeColors.error
                        : (widget.isDark
                              ? ThemeColors.darkSurface3
                              : ThemeColors.stitchSurfaceContainerHigh),
                    borderRadius: BorderRadius.circular(4),
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
            Text(
              title,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 10.5,
                color: widget.surfaces.textMuted,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: isSelected
                    ? ThemeColors.error.withValues(alpha: 0.15)
                    : (widget.isDark
                          ? ThemeColors.darkSurface3
                          : ThemeColors.stitchSurfaceContainer),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                badge,
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.bold,
                  color: isSelected
                      ? ThemeColors.error
                      : widget.surfaces.textMuted,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
