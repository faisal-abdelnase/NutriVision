import 'package:flutter/material.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/theme_colors.dart';
import '../../../../core/theme/theme_dimensions.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../../../core/theme/theme_text_styles.dart';
import '../models/info_completion_state.dart';

class MetabolicProfilerCard extends StatelessWidget {
  const MetabolicProfilerCard({super.key, required this.data});

  final InfoCompletionData data;

  static String _formatNumber(int number) {
    return number.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
  }

  @override
  Widget build(BuildContext context) {
    final surfaces = context.surfaceColors;
    final isDark = context.isDarkMode;
    final locale = Localizations.localeOf(context);
    final isRtl =
        Directionality.of(context) == TextDirection.rtl ||
        locale.languageCode == 'ar';

    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(ThemeDimensions.spaceLg),
          decoration: BoxDecoration(
            color: const Color(0xFF0B1120),
            borderRadius: BorderRadius.circular(20),
            boxShadow: const [
              BoxShadow(
                color: Color(0x33000000),
                blurRadius: 18,
                offset: Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                alignment: WrapAlignment.spaceBetween,
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 8,
                runSpacing: 6,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 7,
                          height: 7,
                          decoration: const BoxDecoration(
                            color: ThemeColors.stitchPrimaryFixed,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          isRtl
                              ? 'محلل الأيض الحيوي NUTRIVISION'
                              : 'NUTRIVISION METABOLIC PROFILER',
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: ThemeColors.stitchPrimaryFixed,
                            letterSpacing: 0.8,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Text(
                    'AI:Harris-Mifflin.v4',
                    style: TextStyle(
                      fontSize: 11,
                      fontFamily: 'monospace',
                      color: Color(0xFF94A3B8),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              Text(
                isRtl
                    ? 'معايرة خط الأساس الأيضي بدقة سريرية متقدمة.'
                    : 'Calibrating baseline metabolism with clinical precision.',
                style: TextStyle(
                  fontFamily: ThemeTextStyles.headingFamilyFor(locale),
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  height: 1.25,
                  color: const Color(0xFFEEF0FF),
                  letterSpacing: -0.4,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                isRtl
                    ? 'يعتمد NutriVision على معادلتي ميفلين-سانت جور وهاريس-بينديكت المعتمدتين سريرياً لتحديد معدل الأيض الأساسي (BMR) ومجموع استهلاك الطاقة اليومي (TDEE).'
                    : 'NutriVision utilizes clinically validated Mifflin-St Jeor and Harris-Benedict formulas to determine your Basal Metabolic Rate (BMR) and Total Daily Energy Expenditure (TDEE).',
                style: const TextStyle(
                  fontSize: 13,
                  height: 1.5,
                  color: Color(0xFFCBD5E1),
                ),
              ),
              const SizedBox(height: 20),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(ThemeDimensions.spaceMd),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B).withValues(alpha: 0.9),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.08),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.monitor_heart_rounded,
                          color: ThemeColors.stitchPrimaryFixed,
                          size: 19,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          isRtl
                              ? 'مخرجات القياس الحيوي الحية'
                              : 'Dynamic Telemetry Output',
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: const Color(
                                0xFF0B1120,
                              ).withValues(alpha: 0.8),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  isRtl
                                      ? 'معدل الأيض الأساسي (BMR)'
                                      : 'Estimated BMR',
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: Color(0xFF94A3B8),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.baseline,
                                  textBaseline: TextBaseline.alphabetic,
                                  children: [
                                    Text(
                                      _formatNumber(data.bmr.round()),
                                      style: const TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        fontFamily: 'monospace',
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      isRtl ? 'سعرة/يوم' : 'kcal/d',
                                      style: const TextStyle(
                                        fontSize: 11,
                                        color: Color(0xFF94A3B8),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  isRtl
                                      ? 'الحد الأدنى للطاقة الحيوية'
                                      : 'Basal floor threshold',
                                  style: const TextStyle(
                                    fontSize: 10,
                                    color: ThemeColors.stitchPrimaryFixed,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: const Color(
                                0xFF0B1120,
                              ).withValues(alpha: 0.8),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  isRtl
                                      ? 'إجمالي الاستهلاك اليومي (TDEE)'
                                      : 'Estimated TDEE',
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: Color(0xFF94A3B8),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.baseline,
                                  textBaseline: TextBaseline.alphabetic,
                                  children: [
                                    Text(
                                      _formatNumber(data.tdee.round()),
                                      style: const TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        color: ThemeColors.stitchPrimaryFixed,
                                        fontFamily: 'monospace',
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      isRtl ? 'سعرة/يوم' : 'kcal/d',
                                      style: const TextStyle(
                                        fontSize: 11,
                                        color: Color(0xFF94A3B8),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  isRtl
                                      ? 'الاستهلاك التكيفي مع النشاط'
                                      : 'Adaptive activity target',
                                  style: const TextStyle(
                                    fontSize: 10,
                                    color: Color(0xFF6EE7B7),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0B1120).withValues(alpha: 0.8),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Wrap(
                            alignment: WrapAlignment.spaceBetween,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            spacing: 8,
                            runSpacing: 4,
                            children: [
                              Text(
                                isRtl
                                    ? 'توزيع المغذيات الكبرى المستهدف'
                                    : 'Macro Target Partition',
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: Color(0xFFCBD5E1),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                isRtl
                                    ? 'توازن سريري 40/30/30'
                                    : 'Balanced 40/30/30',
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: ThemeColors.stitchPrimaryFixed,
                                  fontFamily: 'monospace',
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),

                          ClipRRect(
                            borderRadius: BorderRadius.circular(999),
                            child: SizedBox(
                              height: 8,
                              child: Row(
                                children: const [
                                  Expanded(
                                    flex: 40,
                                    child: DecoratedBox(
                                      decoration: BoxDecoration(
                                        color: Color(0xFF5BB8FE),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 30,
                                    child: DecoratedBox(
                                      decoration: BoxDecoration(
                                        color: Color(0xFF10B981),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 30,
                                    child: DecoratedBox(
                                      decoration: BoxDecoration(
                                        color: Color(0xFFFF7E2D),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _buildMacroItem(
                                isRtl ? 'الكربوهيدرات' : 'Carbohydrates',
                                '${((data.tdee * 0.4) / 4).round()}g',
                                const Color(0xFF93CCFF),
                              ),
                              _buildMacroItem(
                                isRtl ? 'البروتين' : 'Protein',
                                '${((data.tdee * 0.3) / 4).round()}g',
                                ThemeColors.stitchPrimaryFixed,
                              ),
                              _buildMacroItem(
                                isRtl ? 'الدهون الصحية' : 'Healthy Fats',
                                '${((data.tdee * 0.3) / 9).round()}g',
                                const Color(0xFFFFB690),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              Row(
                children: [
                  const Icon(
                    Icons.verified_user_rounded,
                    color: ThemeColors.stitchPrimaryFixed,
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      isRtl
                          ? 'بيانات صحية مشفرة بالكامل • متوافق مع معايير HIPAA و GDPR'
                          : 'Encrypted Health Telemetry • HIPAA & GDPR Compliant',
                      style: const TextStyle(
                        fontSize: 11,
                        color: Color(0xFF94A3B8),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: ThemeDimensions.spaceMd),

        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(ThemeDimensions.spaceMd),
          decoration: BoxDecoration(
            color: isDark
                ? ThemeColors.darkSurface1
                : ThemeColors.stitchSurfaceContainerLow,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isDark
                  ? ThemeColors.darkBorder
                  : ThemeColors.stitchSurfaceContainerHighest.withValues(
                      alpha: 0.6,
                    ),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: ThemeColors.stitchPrimary.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Icon(
                    Icons.medical_information_rounded,
                    color: ThemeColors.stitchPrimary,
                    size: 24,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isRtl
                          ? '«إن دقة القياسات الحيوية الأولية هي حجر الأساس للتحكم الاستباقي في مؤشر السكر والحيوية المستدامة. هذه الدقة هي ما يضبط كل حصة غذائية مقترحة لك.»'
                          : '"Accurate physical baselines are the cornerstone of proactive glycemic control and sustainable vitality. Precision here governs every micro-nutrient recommendation."',
                      style: TextStyle(
                        fontSize: 12,
                        fontStyle: isRtl ? FontStyle.normal : FontStyle.italic,
                        color: surfaces.textPrimary,
                        height: 1.45,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(
                          isRtl
                              ? 'د. سارة المنصور'
                              : 'Dr. Sarah Al-Mansoor, MD',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: surfaces.textPrimary,
                          ),
                        ),
                        Text(
                          isRtl
                              ? ' • استشارية التغذية الإكلينيكية'
                              : ' • Lead Clinical Dietitian',
                          style: TextStyle(
                            fontSize: 11,
                            color: surfaces.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: ThemeDimensions.spaceMd),

        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Container(
            height: 140,
            width: double.infinity,
            decoration: const BoxDecoration(color: Color(0xFF1E293B)),
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(
                  'assets/images/onboarding/clinical_lab.jpg',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: const Color(0xFF131B2E),
                      child: const Center(
                        child: Icon(
                          Icons.biotech_rounded,
                          color: ThemeColors.stitchPrimaryContainer,
                          size: 40,
                        ),
                      ),
                    );
                  },
                ),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        const Color(0xFF0B1120).withValues(alpha: 0.85),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  left: 16,
                  right: 16,
                  bottom: 12,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isRtl
                                ? 'القياسات الحيوية السريرية'
                                : 'BIOMETRIC TELEMETRY',
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.8,
                              color: ThemeColors.stitchPrimaryFixed,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            isRtl
                                ? 'بنية أيضية معتمدة وموثوقة'
                                : 'Validated Metabolic Architecture',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      const Icon(
                        Icons.biotech_rounded,
                        color: ThemeColors.stitchPrimaryFixed,
                        size: 24,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMacroItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: color,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontFamily: 'monospace',
          ),
        ),
      ],
    );
  }
}
