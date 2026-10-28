import 'package:flutter/material.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/theme_colors.dart';
import '../../../../core/theme/theme_dimensions.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../../../core/theme/theme_text_styles.dart';

class InfoStepperHeader extends StatelessWidget {
  const InfoStepperHeader({
    super.key,
    required this.currentStep,
    required this.onStepTapped,
  });

  final int currentStep;
  final ValueChanged<int> onStepTapped;

  @override
  Widget build(BuildContext context) {
    final surfaces = context.surfaceColors;
    final isDark = context.isDarkMode;
    final locale = Localizations.localeOf(context);

    final bg = isDark
        ? ThemeColors.darkSurface1
        : ThemeColors.stitchSurfaceContainerLow;

    return Container(
      width: double.infinity,
      color: bg,
      padding: const EdgeInsets.symmetric(
        horizontal: ThemeDimensions.marginMobile,
        vertical: ThemeDimensions.spaceMd,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1280),
          child: _buildHeaderContent(context, surfaces, isDark, locale),
        ),
      ),
    );
  }

  Widget _buildHeaderContent(
    BuildContext context,
    AppSurfaceColors surfaces,
    bool isDark,
    Locale locale,
  ) {
    switch (currentStep) {
      case 0:
        return _buildStep1Header(context, surfaces, isDark, locale);
      case 1:
        return _buildStep2Header(context, surfaces, isDark, locale);
      case 2:
      default:
        return _buildStep3Header(context, surfaces, isDark, locale);
    }
  }

  Widget _buildStep1Header(
    BuildContext context,
    AppSurfaceColors surfaces,
    bool isDark,
    Locale locale,
  ) {
    final isRtl =
        Directionality.of(context) == TextDirection.rtl ||
        locale.languageCode == 'ar';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            final isDesktop = constraints.maxWidth >= 768;
            final titleCol = Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 8,
                  runSpacing: 4,
                  children: [
                    Text(
                      isRtl
                          ? 'الخطوة 1 من 3 • القياسات الحيوية والتمثيل الغذائي'
                          : 'STEP 1 OF 3 • BIOMETRICS & METABOLIC BASE',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        letterSpacing: isRtl ? 0.0 : 0.8,
                        color: isDark
                            ? ThemeColors.stitchPrimaryDark
                            : ThemeColors.stitchPrimary,
                      ),
                    ),
                    Container(
                      width: 5,
                      height: 5,
                      decoration: const BoxDecoration(
                        color: ThemeColors.stitchPrimaryContainer,
                        shape: BoxShape.circle,
                      ),
                    ),
                    Text(
                      isRtl ? 'جلسة #NV-8842' : 'Session #NV-8842',
                      style: TextStyle(fontSize: 11, color: surfaces.textMuted),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  isRtl
                      ? 'معايرة خط الأساس البدني'
                      : 'Physical Baseline Calibration',
                  style: TextStyle(
                    fontFamily: ThemeTextStyles.headingFamilyFor(locale),
                    fontSize: isDesktop ? 26 : 21,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                    color: surfaces.textPrimary,
                  ),
                ),
              ],
            );

            final trackCol = SizedBox(
              width: isDesktop ? 390 : double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _StepPill(
                          stepNum: 1,
                          label: isRtl ? 'القياسات' : 'Biometrics',
                          isActive: true,
                          isDark: isDark,
                          onTap: () => onStepTapped(0),
                        ),
                        const SizedBox(width: 8),
                        _StepPill(
                          stepNum: 2,
                          label: isRtl ? 'الأهداف' : 'Dietary Goals',
                          isActive: false,
                          isDark: isDark,
                          onTap: () => onStepTapped(1),
                        ),
                        const SizedBox(width: 8),
                        _StepPill(
                          stepNum: 3,
                          label: isRtl ? 'التفضيلات' : 'Preferences',
                          isActive: false,
                          isDark: isDark,
                          onTap: () => onStepTapped(2),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(999),
                    child: Container(
                      height: 6,
                      width: double.infinity,
                      color: isDark
                          ? ThemeColors.darkSurface3
                          : ThemeColors.stitchSurfaceContainerHighest,
                      child: FractionallySizedBox(
                        alignment: AlignmentDirectional.centerStart,
                        widthFactor: 0.33,
                        child: Container(
                          decoration: BoxDecoration(
                            color: isDark
                                ? ThemeColors.stitchPrimaryDark
                                : ThemeColors.stitchPrimaryContainer,
                            borderRadius: BorderRadius.circular(999),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );

            if (isDesktop) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(child: titleCol),
                  const SizedBox(width: 24),
                  trackCol,
                ],
              );
            } else {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [titleCol, const SizedBox(height: 16), trackCol],
              );
            }
          },
        ),
      ],
    );
  }

  Widget _buildStep2Header(
    BuildContext context,
    AppSurfaceColors surfaces,
    bool isDark,
    Locale locale,
  ) {
    final isRtl =
        Directionality.of(context) == TextDirection.rtl ||
        locale.languageCode == 'ar';
    final chevronIcon = isRtl
        ? Icons.arrow_back_ios_rounded
        : Icons.arrow_forward_ios_rounded;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _CompletedBadge(
                stepNum: 1,
                label: isRtl ? 'القياسات' : 'Biometrics',
                onTap: () => onStepTapped(0),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Icon(chevronIcon, size: 12, color: surfaces.textMuted),
              ),
              _ActiveBadge(
                stepNum: 2,
                label: isRtl ? 'الأهداف الغذائية' : 'Dietary Goals',
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Icon(chevronIcon, size: 12, color: surfaces.textMuted),
              ),
              _PendingBadge(
                stepNum: 3,
                label: isRtl ? 'التفضيلات' : 'Preferences',
                onTap: () => onStepTapped(2),
              ),
              const SizedBox(width: 16),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: isDark
                      ? ThemeColors.darkSurface2
                      : ThemeColors.stitchSurfaceContainerHighest.withValues(
                          alpha: 0.5,
                        ),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  isRtl ? 'الخطوة 2 من 3' : 'STEP 2 OF 3',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    letterSpacing: isRtl ? 0.0 : 0.8,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStep3Header(
    BuildContext context,
    AppSurfaceColors surfaces,
    bool isDark,
    Locale locale,
  ) {
    final isRtl =
        Directionality.of(context) == TextDirection.rtl ||
        locale.languageCode == 'ar';

    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth >= 860;

        final titleCol = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isRtl
                  ? 'الخطوة 3 من 3 • التفضيلات الغذائية وموانع الحساسية'
                  : 'STEP 3 OF 3 • DIETARY PREFERENCES & ALLERGEN FILTERS',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                letterSpacing: isRtl ? 0.0 : 0.8,
                color: isDark
                    ? ThemeColors.stitchPrimaryDark
                    : ThemeColors.stitchPrimary,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              isRtl
                  ? 'تخصيص القواعد ومحددات الأمان السريرية'
                  : 'Personalize dietary rules & safety constraints',
              style: TextStyle(fontSize: 11, color: surfaces.textMuted),
            ),
          ],
        );

        final badgesRow = SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _CompletedBadge(
                stepNum: 1,
                label: isRtl ? 'القياسات' : 'Biometrics',
                subLabel: isRtl ? 'تم التحقق' : 'Validated',
                onTap: () => onStepTapped(0),
              ),
              Container(
                width: 16,
                height: 2,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                color: ThemeColors.stitchPrimaryContainer,
              ),
              _CompletedBadge(
                stepNum: 2,
                label: isRtl ? 'الأهداف' : 'Metabolic Goals',
                subLabel: isRtl ? 'تم الضبط' : 'Locked',
                onTap: () => onStepTapped(1),
              ),
              Container(
                width: 16,
                height: 2,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                color: ThemeColors.stitchPrimary,
              ),
              _ActiveBadge(
                stepNum: 3,
                label: isRtl
                    ? 'الحماية والتفضيلات'
                    : 'Safeguards & Preferences',
                subLabel: isRtl ? 'الخطوة الحالية' : 'Active Intake Step',
              ),
            ],
          ),
        );

        if (isDesktop) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: titleCol),
              const SizedBox(width: 16),
              badgesRow,
            ],
          );
        } else {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [titleCol, const SizedBox(height: 12), badgesRow],
          );
        }
      },
    );
  }
}

class _StepPill extends StatelessWidget {
  const _StepPill({
    required this.stepNum,
    required this.label,
    required this.isActive,
    required this.isDark,
    required this.onTap,
  });

  final int stepNum;
  final String label;
  final bool isActive;
  final bool isDark;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final primary = isDark
        ? ThemeColors.stitchPrimaryDark
        : ThemeColors.stitchPrimary;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: isActive
                    ? primary
                    : (isDark
                          ? ThemeColors.darkSurface3
                          : ThemeColors.stitchSurfaceContainerHighest),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  '$stepNum',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: isActive ? Colors.white : ThemeColors.slate400,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                color: isActive ? primary : ThemeColors.slate500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CompletedBadge extends StatelessWidget {
  const _CompletedBadge({
    required this.stepNum,
    required this.label,
    this.subLabel,
    this.onTap,
  });

  final int stepNum;
  final String label;
  final String? subLabel;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: ThemeColors.stitchPrimaryContainer.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(999),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 18,
              height: 18,
              decoration: const BoxDecoration(
                color: ThemeColors.stitchPrimaryContainer,
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Icon(Icons.check, size: 12, color: Colors.white),
              ),
            ),
            const SizedBox(width: 6),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '$stepNum. $label',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: ThemeColors.stitchPrimary,
                  ),
                ),
                if (subLabel != null)
                  Text(
                    subLabel!,
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: ThemeColors.stitchPrimaryContainer,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ActiveBadge extends StatelessWidget {
  const _ActiveBadge({
    required this.stepNum,
    required this.label,
    this.subLabel,
  });

  final int stepNum;
  final String label;
  final String? subLabel;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: ThemeColors.stitchPrimary,
        borderRadius: BorderRadius.circular(999),
        boxShadow: const [
          BoxShadow(
            color: Color(0x33006C49),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 18,
            height: 18,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '$stepNum',
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: ThemeColors.stitchPrimary,
                ),
              ),
            ),
          ),
          const SizedBox(width: 6),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              if (subLabel != null)
                Text(
                  subLabel!,
                  style: const TextStyle(
                    fontSize: 9.5,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFFCCE5FF),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PendingBadge extends StatelessWidget {
  const _PendingBadge({required this.stepNum, required this.label, this.onTap});

  final int stepNum;
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: ThemeColors.stitchSurfaceContainerHighest.withValues(
            alpha: 0.5,
          ),
          borderRadius: BorderRadius.circular(999),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 18,
              height: 18,
              decoration: const BoxDecoration(
                color: ThemeColors.slate400,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  '$stepNum',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: ThemeColors.slate600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
