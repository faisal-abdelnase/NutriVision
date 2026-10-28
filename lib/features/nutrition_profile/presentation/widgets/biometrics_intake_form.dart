import 'package:flutter/material.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/theme_colors.dart';
import '../../../../core/theme/theme_dimensions.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../../../core/theme/theme_text_styles.dart';
import '../models/info_completion_state.dart';

class BiometricsIntakeForm extends StatelessWidget {
  const BiometricsIntakeForm({
    super.key,
    required this.data,
    required this.onDataChanged,
    required this.onNext,
    required this.onBack,
  });

  final InfoCompletionData data;
  final ValueChanged<InfoCompletionData> onDataChanged;
  final VoidCallback onNext;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final surfaces = context.surfaceColors;
    final isDark = context.isDarkMode;
    final locale = Localizations.localeOf(context);
    final isRtl =
        Directionality.of(context) == TextDirection.rtl ||
        locale.languageCode == 'ar';

    final cardBg = isDark
        ? ThemeColors.darkSurface1
        : ThemeColors.stitchSurfaceContainerLowest;
    final wellBg = isDark
        ? ThemeColors.darkSurface2
        : ThemeColors.stitchSurfaceContainerLow;
    final border = isDark ? ThemeColors.darkBorder : ThemeColors.slate200;

    return Container(
      padding: const EdgeInsets.all(ThemeDimensions.spaceLg),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: border),
        boxShadow: isDark
            ? null
            : const [
                BoxShadow(
                  color: Color(0x08000000),
                  blurRadius: 14,
                  offset: Offset(0, 4),
                ),
              ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: isDark
                  ? ThemeColors.darkSurface3
                  : ThemeColors.stitchSurfaceContainer,
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              isRtl ? 'المدخلات الشخصية' : 'PERSONALIZED INTAKE',
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: ThemeColors.stitchPrimary,
                letterSpacing: 0.8,
              ),
            ),
          ),
          const SizedBox(height: 8),

          Text(
            isRtl
                ? 'أدخل قياساتك الحيوية الأساسية'
                : 'Tell us about your physical baseline',
            style: TextStyle(
              fontFamily: ThemeTextStyles.headingFamilyFor(locale),
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: surfaces.textPrimary,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            isRtl
                ? 'نستخدم هذه القياسات حصرياً لحساب الحد الأدنى من السعرات الحرارية وتحديد الاحتياج اليومي من المغذيات. بياناتك مشفرة ومحفوظة بخصوصية تامة.'
                : 'We use these metrics exclusively to calculate your daily caloric floor and nutrient partition limits. Your data is strictly private and never shared.',
            style: TextStyle(
              fontSize: 13,
              height: 1.45,
              color: surfaces.textSecondary,
            ),
          ),
          const SizedBox(height: 20),

          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: wellBg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Wrap(
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 8,
              runSpacing: 6,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    isRtl ? 'نظام القياس' : 'Measurement System',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: surfaces.textPrimary,
                    ),
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildPillTab(
                      label: isRtl ? 'متري: سم / كغ' : 'Metric: cm / kg',
                      isSelected: data.system == MeasurementSystem.metric,
                      onTap: () {
                        onDataChanged(
                          data.copyWith(system: MeasurementSystem.metric),
                        );
                      },
                      isDark: isDark,
                    ),
                    const SizedBox(width: 4),
                    _buildPillTab(
                      label: isRtl
                          ? 'إمبراطوري: قدم / رطل'
                          : 'Imperial: ft / lbs',
                      isSelected: data.system == MeasurementSystem.imperial,
                      onTap: () {
                        onDataChanged(
                          data.copyWith(system: MeasurementSystem.imperial),
                        );
                      },
                      isDark: isDark,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          Text(
            isRtl
                ? 'الجنس البيولوجي (لحساب النموذج الحراري)'
                : 'Biological Sex (For Caloric Modeling)',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: surfaces.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _buildGenderCard(
                  sex: BiologicalSex.male,
                  title: isRtl ? 'ذكر' : 'Male',
                  subtitle: isRtl ? 'معامل هاريس الأساسي' : 'Harris base ratio',
                  icon: Icons.male_rounded,
                  isSelected: data.sex == BiologicalSex.male,
                  isDark: isDark,
                  onTap: () =>
                      onDataChanged(data.copyWith(sex: BiologicalSex.male)),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildGenderCard(
                  sex: BiologicalSex.female,
                  title: isRtl ? 'أنثى' : 'Female',
                  subtitle: isRtl ? 'المعامل القياسي' : 'Selected default',
                  icon: Icons.female_rounded,
                  isSelected: data.sex == BiologicalSex.female,
                  isDark: isDark,
                  onTap: () =>
                      onDataChanged(data.copyWith(sex: BiologicalSex.female)),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildGenderCard(
                  sex: BiologicalSex.other,
                  title: isRtl ? 'آخر' : 'Other',
                  subtitle: isRtl ? 'خط أساس محايد' : 'Neutral baseline',
                  icon: Icons.transgender_rounded,
                  isSelected: data.sex == BiologicalSex.other,
                  isDark: isDark,
                  onTap: () =>
                      onDataChanged(data.copyWith(sex: BiologicalSex.other)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isRtl ? 'العمر' : 'Age',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: surfaces.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      height: 48,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                        color: wellBg,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            onPressed: () {
                              if (data.age > 16) {
                                onDataChanged(data.copyWith(age: data.age - 1));
                              }
                            },
                            icon: const Icon(Icons.remove, size: 16),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(
                              minWidth: 32,
                              minHeight: 32,
                            ),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '${data.age}',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: surfaces.textPrimary,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                isRtl ? 'سنة' : 'yrs',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: surfaces.textMuted,
                                ),
                              ),
                            ],
                          ),
                          IconButton(
                            onPressed: () {
                              if (data.age < 99) {
                                onDataChanged(data.copyWith(age: data.age + 1));
                              }
                            },
                            icon: const Icon(Icons.add, size: 16),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(
                              minWidth: 32,
                              minHeight: 32,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      isRtl
                          ? 'النطاق الأيضي للبالغين 18–85'
                          : 'Adult metabolic range 18–85',
                      style: TextStyle(fontSize: 11, color: surfaces.textMuted),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 14),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isRtl ? 'الطول' : 'Height',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: surfaces.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      height: 48,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: wellBg,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.height_rounded,
                            size: 18,
                            color: surfaces.textMuted,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextFormField(
                              initialValue:
                                  data.system == MeasurementSystem.metric
                                  ? data.heightCm.toStringAsFixed(0)
                                  : (data.heightCm / 2.54).toStringAsFixed(0),
                              key: ValueKey(
                                'height_${data.system}_${data.heightCm}',
                              ),
                              keyboardType: TextInputType.number,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: surfaces.textPrimary,
                              ),
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding: EdgeInsets.zero,
                              ),
                              onChanged: (val) {
                                final parsed = double.tryParse(val);
                                if (parsed != null && parsed > 50) {
                                  final cm =
                                      data.system == MeasurementSystem.metric
                                      ? parsed
                                      : parsed * 2.54;
                                  onDataChanged(data.copyWith(heightCm: cm));
                                }
                              },
                            ),
                          ),
                          Text(
                            data.system == MeasurementSystem.metric
                                ? (isRtl ? 'سم' : 'cm')
                                : (isRtl ? 'بوصة' : 'in'),
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: ThemeColors.stitchPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      data.system == MeasurementSystem.metric
                          ? (isRtl
                                ? 'المدى الطبيعي 120–220 سم'
                                : 'Normal bounds 120–220 cm')
                          : (isRtl
                                ? 'المدى الطبيعي 48–86 بوصة'
                                : 'Normal bounds 48–86 in'),
                      style: TextStyle(fontSize: 11, color: surfaces.textMuted),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    isRtl ? 'الوزن الحالي' : 'Current Weight',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: surfaces.textPrimary,
                    ),
                  ),
                  Text(
                    isRtl ? 'معايرة تلقائية' : 'Auto-calibrated floor',
                    style: TextStyle(fontSize: 11, color: surfaces.textMuted),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Container(
                height: 48,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: wellBg,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.scale_rounded,
                      size: 18,
                      color: surfaces.textMuted,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextFormField(
                        initialValue: data.system == MeasurementSystem.metric
                            ? data.weightKg.toStringAsFixed(1)
                            : (data.weightKg * 2.20462).toStringAsFixed(1),
                        key: ValueKey('weight_${data.system}_${data.weightKg}'),
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: surfaces.textPrimary,
                        ),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                        onChanged: (val) {
                          final parsed = double.tryParse(val);
                          if (parsed != null && parsed > 20) {
                            final kg = data.system == MeasurementSystem.metric
                                ? parsed
                                : parsed / 2.20462;
                            onDataChanged(data.copyWith(weightKg: kg));
                          }
                        },
                      ),
                    ),
                    Text(
                      data.system == MeasurementSystem.metric
                          ? (isRtl ? 'كغ' : 'kg')
                          : (isRtl ? 'رطل' : 'lbs'),
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: ThemeColors.stitchPrimary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(
                    Icons.info_outline_rounded,
                    size: 14,
                    color: ThemeColors.stitchPrimary,
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      isRtl
                          ? 'أهمية القياس: ضروري لحساب الكتلة الحيوية وتحديد الاحتياج الأدنى من البروتين.'
                          : 'Why we ask: Essential for calculating lean mass and protein target thresholds.',
                      style: TextStyle(fontSize: 11, color: surfaces.textMuted),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),

          Text(
            isRtl
                ? 'مستوى النشاط البدني (المعامل الأيضي)'
                : 'Physical Activity Level (Metabolic Multiplier)',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: surfaces.textPrimary,
            ),
          ),
          const SizedBox(height: 8),

          LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth >= 540;
              final cards = [
                _buildActivityCard(
                  factor: 1.2,
                  title: isRtl ? 'خامل' : 'Sedentary',
                  multiplier: '1.2×',
                  description: isRtl
                      ? 'نشاط خفيف أو معدوم، عمل مكتبي'
                      : 'Little to no exercise, desk work',
                  icon: Icons.weekend_rounded,
                  isSelected: data.activityMultiplier == 1.2,
                  isDark: isDark,
                  surfaces: surfaces,
                  onTap: () =>
                      onDataChanged(data.copyWith(activityMultiplier: 1.2)),
                ),
                _buildActivityCard(
                  factor: 1.375,
                  title: isRtl ? 'نشاط خفيف' : 'Lightly Active',
                  multiplier: '1.375×',
                  description: isRtl
                      ? 'تمارين خفيفة 1–3 أيام أسبوعياً'
                      : 'Light exercise 1–3 days/week',
                  icon: Icons.directions_walk_rounded,
                  isSelected: data.activityMultiplier == 1.375,
                  isDark: isDark,
                  surfaces: surfaces,
                  onTap: () =>
                      onDataChanged(data.copyWith(activityMultiplier: 1.375)),
                ),
                _buildActivityCard(
                  factor: 1.55,
                  title: isRtl ? 'نشاط معتدل' : 'Moderately Active',
                  multiplier: '1.55×',
                  description: isRtl
                      ? 'تمارين معتدلة 3–5 أيام أسبوعياً'
                      : 'Moderate exercise 3–5 days/week',
                  icon: Icons.directions_run_rounded,
                  isSelected: data.activityMultiplier == 1.55,
                  isDark: isDark,
                  surfaces: surfaces,
                  onTap: () =>
                      onDataChanged(data.copyWith(activityMultiplier: 1.55)),
                ),
                _buildActivityCard(
                  factor: 1.725,
                  title: isRtl ? 'نشط جداً' : 'Very Active',
                  multiplier: '1.725×',
                  description: isRtl
                      ? 'تمارين شاقة 6–7 أيام، تدريب رياضي مكثف'
                      : 'Intense exercise 6–7 days/week, athletic',
                  icon: Icons.fitness_center_rounded,
                  isSelected: data.activityMultiplier == 1.725,
                  isDark: isDark,
                  surfaces: surfaces,
                  onTap: () =>
                      onDataChanged(data.copyWith(activityMultiplier: 1.725)),
                ),
              ];

              if (isWide) {
                return Column(
                  children: [
                    Row(
                      children: [
                        Expanded(child: cards[0]),
                        const SizedBox(width: 8),
                        Expanded(child: cards[1]),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(child: cards[2]),
                        const SizedBox(width: 8),
                        Expanded(child: cards[3]),
                      ],
                    ),
                  ],
                );
              } else {
                return Column(
                  children: [
                    cards[0],
                    const SizedBox(height: 8),
                    cards[1],
                    const SizedBox(height: 8),
                    cards[2],
                    const SizedBox(height: 8),
                    cards[3],
                  ],
                );
              }
            },
          ),
          const SizedBox(height: 24),

          LayoutBuilder(
            builder: (context, constraints) {
              final isNarrow = constraints.maxWidth < 420;
              final nextBtn = FilledButton.icon(
                onPressed: onNext,
                label: Text(
                  isRtl
                      ? 'المتابعة إلى الأهداف الغذائية'
                      : 'Continue to Dietary Goals',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                icon: Icon(
                  isRtl
                      ? Icons.arrow_back_rounded
                      : Icons.arrow_forward_rounded,
                  size: 18,
                ),
                style: FilledButton.styleFrom(
                  backgroundColor: ThemeColors.stitchPrimary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(999),
                  ),
                  elevation: 2,
                ),
              );

              final backBtn = OutlinedButton.icon(
                onPressed: onBack,
                icon: Icon(
                  isRtl
                      ? Icons.arrow_forward_rounded
                      : Icons.arrow_back_rounded,
                  size: 18,
                ),
                label: Text(isRtl ? 'السابق' : 'Back'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(999),
                  ),
                  side: BorderSide(color: border),
                  foregroundColor: surfaces.textPrimary,
                ),
              );

              if (isNarrow) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [nextBtn, const SizedBox(height: 10), backBtn],
                );
              }

              return Wrap(
                alignment: WrapAlignment.spaceBetween,
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 12,
                runSpacing: 10,
                children: [backBtn, nextBtn],
              );
            },
          ),
          const SizedBox(height: 12),

          Center(
            child: Text(
              isRtl
                  ? 'يقدم NutriVision تقديرات غذائية وإرشادية. لا تُعد بديلاً عن التشخيص الطبي المتخصص. استشر طبيبك دائماً.'
                  : 'NutriVision provides estimated dietary insights. Not intended for clinical or medical diagnosis. Always consult your physician.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 11, color: surfaces.textMuted),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPillTab({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
    required bool isDark,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? ThemeColors.stitchPrimary : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: isSelected
                ? Colors.white
                : (isDark
                      ? ThemeColors.darkTextSecondary
                      : ThemeColors.slate600),
          ),
        ),
      ),
    );
  }

  Widget _buildGenderCard({
    required BiologicalSex sex,
    required String title,
    required String subtitle,
    required IconData icon,
    required bool isSelected,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    final border = isSelected
        ? ThemeColors.stitchPrimary
        : (isDark ? ThemeColors.darkBorder : ThemeColors.slate200);
    final bg = isSelected
        ? ThemeColors.stitchPrimaryContainer.withValues(alpha: 0.12)
        : (isDark
              ? ThemeColors.darkSurface2
              : ThemeColors.stitchSurfaceContainerLow);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: border, width: isSelected ? 1.5 : 1),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 20,
              color: isSelected
                  ? ThemeColors.stitchPrimary
                  : (isDark ? ThemeColors.slate400 : ThemeColors.slate600),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: isSelected
                          ? ThemeColors.stitchPrimary
                          : (isDark ? Colors.white : ThemeColors.slate900),
                    ),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 9.5,
                      color: ThemeColors.slate500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityCard({
    required double factor,
    required String title,
    required String multiplier,
    required String description,
    required IconData icon,
    required bool isSelected,
    required bool isDark,
    required AppSurfaceColors surfaces,
    required VoidCallback onTap,
  }) {
    final border = isSelected
        ? ThemeColors.stitchPrimary
        : (isDark ? ThemeColors.darkBorder : ThemeColors.slate200);
    final bg = isSelected
        ? ThemeColors.stitchPrimaryContainer.withValues(alpha: 0.1)
        : (isDark
              ? ThemeColors.darkSurface2
              : ThemeColors.stitchSurfaceContainerLow);

    return InkWell(
      onTap: onTap,
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
                Expanded(
                  child: Row(
                    children: [
                      Icon(
                        icon,
                        size: 18,
                        color: isSelected
                            ? ThemeColors.stitchPrimary
                            : surfaces.textSecondary,
                      ),
                      const SizedBox(width: 6),
                      Flexible(
                        child: Text(
                          title,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: surfaces.textPrimary,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 6),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      multiplier,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'monospace',
                        color: isSelected
                            ? ThemeColors.stitchPrimary
                            : surfaces.textMuted,
                      ),
                    ),
                    if (isSelected) ...[
                      const SizedBox(width: 4),
                      const Icon(
                        Icons.check_circle_rounded,
                        size: 16,
                        color: ThemeColors.stitchPrimary,
                      ),
                    ],
                  ],
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              description,
              style: TextStyle(
                fontSize: 11,
                color: surfaces.textMuted,
                height: 1.3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
