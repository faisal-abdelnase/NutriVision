import 'package:flutter/material.dart';
import '../../../../core/theme/theme_colors.dart';
import '../../../../core/theme/theme_dimensions.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../models/info_completion_state.dart';

class SafetyTelemetryCard extends StatelessWidget {
  const SafetyTelemetryCard({
    super.key,
    required this.data,
    required this.surfaces,
    required this.isDark,
    required this.isRtl,
  });

  final InfoCompletionData data;
  final AppSurfaceColors surfaces;
  final bool isDark;
  final bool isRtl;

  @override
  Widget build(BuildContext context) {
    final cardBg = isDark
        ? ThemeColors.darkSurface1
        : ThemeColors.stitchSurfaceContainerLowest;
    final wellBg = isDark
        ? ThemeColors.darkSurface2
        : ThemeColors.stitchSurfaceContainer;
    final border = isDark ? ThemeColors.darkBorder : ThemeColors.slate200;

    final activeAllergenCount =
        data.selectedAllergens.length + data.customAllergens.length;

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(ThemeDimensions.spaceMd),
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: border),
            boxShadow: isDark
                ? null
                : const [
                    BoxShadow(
                      color: Color(0x0A000000),
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: ThemeColors.stitchPrimaryContainer,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        isRtl
                            ? 'مؤشرات الأمان اللحظية بالذكاء الاصطناعي'
                            : 'LIVE AI SAFETY TELEMETRY',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.8,
                          color: ThemeColors.stitchPrimary,
                        ),
                      ),
                    ],
                  ),
                  const Icon(
                    Icons.psychology_alt_rounded,
                    color: ThemeColors.stitchPrimary,
                    size: 20,
                  ),
                ],
              ),
              const SizedBox(height: 12),

              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: wellBg,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      alignment: WrapAlignment.spaceBetween,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 4,
                      runSpacing: 2,
                      children: [
                        Text(
                          isRtl ? 'معيار السلامة المعتمد' : 'Safety Standard',
                          style: const TextStyle(
                            fontSize: 10,
                            color: ThemeColors.slate500,
                          ),
                        ),
                        const Text(
                          'FDA 2024 / CODEX',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: ThemeColors.stitchPrimary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        const Icon(
                          Icons.check_circle_rounded,
                          size: 13,
                          color: ThemeColors.stitchPrimary,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            isRtl
                                ? 'الاستبعاد الحتمي الصارم نشط'
                                : 'Deterministic Hard Exclusion Active',
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: ThemeColors.stitchPrimary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              Wrap(
                alignment: WrapAlignment.spaceBetween,
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 8,
                runSpacing: 4,
                children: [
                  Text(
                    isRtl
                        ? 'موانع الحساسية النشطة'
                        : 'Active Allergen Exclusions',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: surfaces.textPrimary,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: ThemeColors.errorContainer,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      isRtl
                          ? '$activeAllergenCount مسببات حرجة'
                          : '$activeAllergenCount Critical',
                      style: const TextStyle(
                        fontSize: 9.5,
                        fontWeight: FontWeight.bold,
                        color: ThemeColors.error,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              Column(
                children: [
                  if (data.selectedAllergens.contains('peanuts'))
                    _buildTelemetryRow(
                      title: isRtl ? 'الفول السوداني' : 'Peanuts',
                      sub: isRtl ? 'صدمة تأقية حرجة' : 'الفول السوداني',
                      tag: isRtl ? 'تحذير تأقي' : 'CRITICAL ANAPHYLAXIS',
                      icon: Icons.emergency_rounded,
                    ),
                  if (data.selectedAllergens.contains('seafood'))
                    _buildTelemetryRow(
                      title: isRtl
                          ? 'المأكولات البحرية'
                          : 'Seafood & Shellfish',
                      sub: isRtl ? 'حساسية تنفسية حادة' : 'المأكولات البحرية',
                      tag: isRtl ? 'خطر تنفسي' : 'HIGH RESPIRATORY',
                      icon: Icons.set_meal_rounded,
                    ),
                  ...data.customAllergens.map(
                    (c) => _buildTelemetryRow(
                      title: c,
                      sub: isRtl ? 'استثناء مخصص' : 'Custom Exclusion',
                      tag: isRtl ? 'مخصص' : 'CUSTOM FLAG',
                      icon: Icons.warning_rounded,
                    ),
                  ),
                  if (data.selectedAllergens.isEmpty &&
                      data.customAllergens.isEmpty)
                    Container(
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        isRtl
                            ? 'لا توجد موانع حساسية محددة حالياً.'
                            : 'No allergen exclusions active.',
                        style: TextStyle(
                          fontSize: 11,
                          color: surfaces.textMuted,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 14),

              Wrap(
                alignment: WrapAlignment.spaceBetween,
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 8,
                runSpacing: 4,
                children: [
                  Text(
                    isRtl
                        ? 'محاكاة استبدال الأطعمة الذكية'
                        : 'Dynamic Food Swap Simulation',
                    style: const TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    isRtl ? 'ربط فوري' : 'Real-time Hook',
                    style: const TextStyle(
                      fontSize: 10.5,
                      fontWeight: FontWeight.bold,
                      color: ThemeColors.stitchSecondary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: wellBg,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.block_rounded,
                          size: 14,
                          color: ThemeColors.error,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            isRtl
                                ? 'الأصل: نودلز باد تاي بالمأكولات البحرية والفول السوداني'
                                : 'Original: Seafood Pad Thai with Crushed Peanuts',
                            style: const TextStyle(
                              fontSize: 10.5,
                              decoration: TextDecoration.lineThrough,
                              color: ThemeColors.slate500,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: cardBg,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.autorenew_rounded,
                                size: 16,
                                color: ThemeColors.stitchPrimary,
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  isRtl
                                      ? 'باد تاي الإدمامي والتوفو العضوي الذهبي'
                                      : 'Golden Edamame & Organic Tofu Pad Thai',
                                  style: const TextStyle(
                                    fontSize: 11.5,
                                    fontWeight: FontWeight.bold,
                                    color: ThemeColors.stitchPrimary,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            isRtl
                                ? 'استبدل الذكاء الاصطناعي القشريات بتوفو عضوي غير معدل وراثياً، واستبدل الفول السوداني بزبدة بذور دوار الشمس المحمصة مع تتبيلة السمسم.'
                                : 'AI dynamically substituted shellfish for firm non-GMO tofu & swapped crushed peanuts for roasted sunflower butter sesame glaze.',
                            style: TextStyle(
                              fontSize: 10.5,
                              height: 1.35,
                              color: surfaces.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    isRtl ? 'مخاطر الحساسية' : 'Allergen Risk',
                                    style: const TextStyle(
                                      fontSize: 9.5,
                                      color: ThemeColors.slate500,
                                    ),
                                  ),
                                  const Text(
                                    '0.0% ✓',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: ThemeColors.stitchPrimary,
                                      fontFamily: 'monospace',
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    isRtl ? 'دقة المغذيات' : 'Macro Fidelity',
                                    style: const TextStyle(
                                      fontSize: 9.5,
                                      color: ThemeColors.slate500,
                                    ),
                                  ),
                                  const Text(
                                    '99.4% 📈',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF006398),
                                      fontFamily: 'monospace',
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),

                    Row(
                      children: [
                        const Icon(
                          Icons.check_circle_rounded,
                          size: 13,
                          color: ThemeColors.stitchPrimary,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            isRtl
                                ? 'الحفاظ التام على مستهدف البروتين: ٣٨ غ / حصة'
                                : 'High Protein Target Maintained: 38g / serving',
                            style: const TextStyle(
                              fontSize: 10.5,
                              fontWeight: FontWeight.bold,
                              color: ThemeColors.stitchPrimary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: ThemeColors.stitchPrimaryFixed.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.ssid_chart_rounded,
                      size: 20,
                      color: ThemeColors.stitchPrimary,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isRtl
                                ? 'حماية سريرية من التلوث التبادلي'
                                : 'Clinical Zero Cross-Contact',
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: ThemeColors.stitchPrimary,
                            ),
                          ),
                          Text(
                            isRtl
                                ? 'تنبيهات فورية من آثار المطابخ ومصانع الأغذية'
                                : 'AI Scanner alerts on industrial kitchen traces',
                            style: const TextStyle(
                              fontSize: 9.5,
                              color: ThemeColors.slate600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: ThemeDimensions.spaceMd),

        Container(
          padding: const EdgeInsets.all(ThemeDimensions.spaceMd),
          decoration: BoxDecoration(
            color: isDark
                ? ThemeColors.darkSurface1
                : ThemeColors.stitchSurfaceContainerLow,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: border),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.info_outline_rounded,
                size: 18,
                color: surfaces.textMuted,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  isRtl
                      ? 'هل تحتاج إلى حميات علاجية تخصصية (مثل أمراض الكلى أو السكري أو متلازمة القولون)؟ يمكنك تعديل هذه الإعدادات في أي وقت من ملفك الصحي أو رفع تقريرك الطبي.'
                      : 'Need specialized renal or medical clinical diets? You can modify these settings anytime from your Clinician Integration tab or upload your medical report.',
                  style: TextStyle(
                    fontSize: 11.5,
                    height: 1.4,
                    color: surfaces.textSecondary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTelemetryRow({
    required String title,
    required String sub,
    required String tag,
    required IconData icon,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: ThemeColors.errorContainer.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                Icon(icon, size: 16, color: ThemeColors.error),
                const SizedBox(width: 6),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.bold,
                          color: ThemeColors.error,
                        ),
                      ),
                      Text(
                        sub,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 9.5,
                          color: ThemeColors.slate500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 6),
          Text(
            tag,
            style: const TextStyle(
              fontSize: 8.5,
              fontWeight: FontWeight.bold,
              color: ThemeColors.error,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}
