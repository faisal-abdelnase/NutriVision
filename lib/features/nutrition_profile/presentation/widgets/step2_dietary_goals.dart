import 'package:flutter/material.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/theme_colors.dart';
import '../../../../core/theme/theme_dimensions.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../../../core/theme/theme_text_styles.dart';
import '../models/info_completion_state.dart';
import 'goal_adaptive_preview_panel.dart';
import 'goal_selection_card.dart';

class Step2DietaryGoals extends StatelessWidget {
  const Step2DietaryGoals({
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

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(
        horizontal: ThemeDimensions.marginMobile,
        vertical: ThemeDimensions.spaceLg,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1280),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeadingSection(surfaces, isDark, locale, isRtl),
              const SizedBox(height: ThemeDimensions.spaceXl),

              _buildGoalCardsGrid(surfaces, isDark, isRtl),
              const SizedBox(height: ThemeDimensions.spaceXl),

              GoalAdaptivePreviewPanel(
                data: data,
                surfaces: surfaces,
                isDark: isDark,
                isRtl: isRtl,
              ),
              const SizedBox(height: ThemeDimensions.spaceLg),

              _buildNavigationButtons(surfaces, isDark, isRtl),
              const SizedBox(height: ThemeDimensions.spaceLg),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeadingSection(
    AppSurfaceColors surfaces,
    bool isDark,
    Locale locale,
    bool isRtl,
  ) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth >= 768;

        final titleCol = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: isDark
                    ? ThemeColors.darkSurface2
                    : ThemeColors.stitchSurfaceContainerHigh,
                borderRadius: BorderRadius.circular(999),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.tune_rounded,
                    size: 14,
                    color: ThemeColors.stitchPrimary,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    isRtl
                        ? 'معايرة الأهداف الخوارزمية'
                        : 'ALGORITHMIC TARGET CALIBRATION',
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.8,
                      color: ThemeColors.stitchPrimary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Text(
              isRtl ? 'ما هو هدفك الغذائي الأساسي؟' : "What's your goal?",
              style: TextStyle(
                fontFamily: ThemeTextStyles.headingFamilyFor(locale),
                fontSize: isDesktop ? 36 : 28,
                fontWeight: FontWeight.w800,
                color: surfaces.textPrimary,
                letterSpacing: -0.6,
                height: 1.15,
              ),
            ),
            const SizedBox(height: 8),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 680),
              child: Text(
                isRtl
                    ? 'يقوم NutriVision بضبط توزيع المغذيات الكبرى، السعرات اليومية المستهدفة، والتوصيات التنبؤية بالذكاء الاصطناعي بناءً على غايتك الأساسية.'
                    : 'NutriVision calibrates your macro partitioning, daily caloric targets, and AI predictive insights around your primary dietary objective.',
                style: TextStyle(
                  fontSize: 14,
                  height: 1.5,
                  color: surfaces.textSecondary,
                ),
              ),
            ),
          ],
        );

        final tdeeBadge = Container(
          padding: const EdgeInsets.all(ThemeDimensions.spaceMd),
          decoration: BoxDecoration(
            color: isDark
                ? ThemeColors.darkSurface1
                : ThemeColors.stitchSurfaceContainerLow,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isDark ? ThemeColors.darkBorder : ThemeColors.slate200,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: ThemeColors.stitchPrimary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Center(
                  child: Icon(
                    Icons.monitor_heart_rounded,
                    color: ThemeColors.stitchPrimary,
                    size: 24,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isRtl
                        ? 'تم تثبيت خط الأساس الأيضي'
                        : 'BMR BASELINE ESTABLISHED',
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.8,
                      color: ThemeColors.slate500,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        _formatNumber(data.tdee.round()),
                        style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                          color: surfaces.textPrimary,
                          fontFamily: 'monospace',
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        isRtl
                            ? 'سعرة/يوم الاستهلاك الكلي (TDEE)'
                            : 'kcal/day TDEE',
                        style: TextStyle(
                          fontSize: 12,
                          color: surfaces.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        );

        if (isDesktop) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(child: titleCol),
              const SizedBox(width: 24),
              tdeeBadge,
            ],
          );
        } else {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [titleCol, const SizedBox(height: 16), tdeeBadge],
          );
        }
      },
    );
  }

  Widget _buildGoalCardsGrid(
    AppSurfaceColors surfaces,
    bool isDark,
    bool isRtl,
  ) {
    final cards = [
      GoalSelectionCard(
        goalType: DietaryGoalType.loseWeight,
        icon: Icons.local_fire_department_rounded,
        iconBg: const Color(0xFFCCE5FF),
        iconColor: const Color(0xFF006398),
        tag: isRtl ? 'هدف عجز السعرات' : 'Deficit Bio-Target',
        title: isRtl ? 'إنقاص الوزن' : 'Lose Weight',
        description: isRtl
            ? 'عجز حراري تدريجي ومحسوب لحرق الدهون مع الحفاظ التام على الكتلة العضلية والأيض.'
            : 'Gradual caloric deficit optimized for fat loss while preserving lean mass and metabolic health.',
        targetPace: isRtl ? '-0.5 إلى -0.75 كغ/أسبوع' : '-0.5 to -0.75 kg/wk',
        energyModel: isRtl ? 'عجز ~400 سعرة حرارية' : '~400 kcal deficit',
        isSelected: data.goal == DietaryGoalType.loseWeight,
        isDark: isDark,
        surfaces: surfaces,
        isRtl: isRtl,
        onTap: () =>
            onDataChanged(data.copyWith(goal: DietaryGoalType.loseWeight)),
      ),
      GoalSelectionCard(
        goalType: DietaryGoalType.maintainWeight,
        icon: Icons.balance_rounded,
        iconBg: const Color(0xFFDAE2FD),
        iconColor: const Color(0xFF006398),
        tag: isRtl ? 'توازن الاستقرار الحيوي' : 'Homeostasis Balance',
        title: isRtl ? 'تثبيت الوزن' : 'Maintain Weight',
        description: isRtl
            ? 'توازن غذائي متكامل للحفاظ على استقرار الطاقة والتوازن الأيضي واستدامة المؤشرات الحيوية.'
            : 'Nutritional equilibrium to sustain energy, metabolic homeostasis, and biomarker stability.',
        targetPace: isRtl ? 'تغير < 0.2 كغ/شهر' : 'Variance < 0.2 kg/mo',
        energyModel: isRtl ? '100% توازن طاقي متطابق' : '100% TDEE Iso-Caloric',
        isSelected: data.goal == DietaryGoalType.maintainWeight,
        isDark: isDark,
        surfaces: surfaces,
        isRtl: isRtl,
        onTap: () =>
            onDataChanged(data.copyWith(goal: DietaryGoalType.maintainWeight)),
      ),
      GoalSelectionCard(
        goalType: DietaryGoalType.gainMuscle,
        icon: Icons.fitness_center_rounded,
        iconBg: const Color(0xFFFFDBCA),
        iconColor: const Color(0xFF9D4300),
        tag: isRtl ? 'البناء العضلي التكيفي' : 'Anabolic Optimization',
        title: isRtl ? 'زيادة العضلات' : 'Gain Muscle',
        description: isRtl
            ? 'بروتوكول تضخيم عضلي يركز على توزيع غني بالأحماض الأمينية وفائض حراري محسوب بدقة.'
            : 'Hypertrophy-focused protocol prioritizing leucine-rich protein distribution and controlled surplus.',
        targetPace: isRtl ? '+0.25 إلى +0.4 كغ/أسبوع' : '+0.25 to +0.4 kg/wk',
        energyModel: isRtl ? 'فائض +300 سعرة حرارية' : '+300 kcal surplus',
        isSelected: data.goal == DietaryGoalType.gainMuscle,
        isDark: isDark,
        surfaces: surfaces,
        isRtl: isRtl,
        onTap: () =>
            onDataChanged(data.copyWith(goal: DietaryGoalType.gainMuscle)),
      ),
      GoalSelectionCard(
        goalType: DietaryGoalType.eatHealthier,
        icon: Icons.monitor_heart_rounded,
        iconBg: const Color(0xFF6FFBBE),
        iconColor: const Color(0xFF006C49),
        tag: isRtl ? 'المغذيات والحيوية المتكاملة' : 'Micronutrient & Vitality',
        title: isRtl ? 'نمط حياة صحي' : 'Eat Healthier',
        description: isRtl
            ? 'كثافة مغذيات صغرى، تنوع غذائي مضاد للالتهاب، وثبات منحنى سكر الدم بعد الوجبات.'
            : 'Micronutrient density, anti-inflammatory food diversity, and steady postprandial glucose curves.',
        targetPace: isRtl ? 'ألياف > 35غ ومؤشر 90+' : 'Fiber > 35g & Score 90+',
        energyModel: isRtl ? 'بدائل أيضية نظيفة' : 'Metabolic Clean Swaps',
        isSelected: data.goal == DietaryGoalType.eatHealthier,
        isDark: isDark,
        surfaces: surfaces,
        isRtl: isRtl,
        onTap: () =>
            onDataChanged(data.copyWith(goal: DietaryGoalType.eatHealthier)),
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= 1024) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: cards[0]),
              const SizedBox(width: 14),
              Expanded(child: cards[1]),
              const SizedBox(width: 14),
              Expanded(child: cards[2]),
              const SizedBox(width: 14),
              Expanded(child: cards[3]),
            ],
          );
        } else if (constraints.maxWidth >= 600) {
          return Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: cards[0]),
                  const SizedBox(width: 14),
                  Expanded(child: cards[1]),
                ],
              ),
              const SizedBox(height: 14),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: cards[2]),
                  const SizedBox(width: 14),
                  Expanded(child: cards[3]),
                ],
              ),
            ],
          );
        } else {
          return Column(
            children: [
              cards[0],
              const SizedBox(height: 14),
              cards[1],
              const SizedBox(height: 14),
              cards[2],
              const SizedBox(height: 14),
              cards[3],
            ],
          );
        }
      },
    );
  }

  Widget _buildNavigationButtons(
    AppSurfaceColors surfaces,
    bool isDark,
    bool isRtl,
  ) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isNarrow = constraints.maxWidth < 440;
        final nextBtn = FilledButton.icon(
          onPressed: onNext,
          label: Text(
            isRtl ? 'المتابعة إلى التفضيلات' : 'Continue to Preferences',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          icon: Icon(
            isRtl ? Icons.arrow_back_rounded : Icons.arrow_forward_rounded,
            size: 18,
          ),
          style: FilledButton.styleFrom(
            backgroundColor: ThemeColors.stitchPrimary,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(999),
            ),
            elevation: 2,
          ),
        );

        final backBtn = OutlinedButton.icon(
          onPressed: onBack,
          icon: Icon(
            isRtl ? Icons.arrow_forward_rounded : Icons.arrow_back_rounded,
            size: 18,
          ),
          label: Text(isRtl ? 'العودة للمقاييس الحيوية' : 'Back to Biometrics'),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(999),
            ),
            side: BorderSide(
              color: isDark ? ThemeColors.darkBorder : ThemeColors.slate200,
            ),
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
    );
  }

  static String _formatNumber(int number) {
    return number.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
  }
}
