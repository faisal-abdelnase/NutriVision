import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nutri_vision/core/theme/theme_extensions.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/localization/locale_cubit.dart';
import '../../../../core/theme/theme_colors.dart';
import '../../../../core/theme/theme_cubit.dart';
import '../../../../core/theme/theme_dimensions.dart';
import '../../../../core/theme/theme_text_styles.dart';

class InfoTopAppBar extends StatelessWidget implements PreferredSizeWidget {
  const InfoTopAppBar({
    super.key,
    this.showSimulatorDeck = true,
    this.onMetricSelected,
    this.onImperialSelected,
    this.onToggleAlert,
  });

  final bool showSimulatorDeck;
  final VoidCallback? onMetricSelected;
  final VoidCallback? onImperialSelected;
  final VoidCallback? onToggleAlert;

  @override
  Size get preferredSize => Size.fromHeight(showSimulatorDeck ? 104 : 64);

  @override
  Widget build(BuildContext context) {
    final surfaces = context.surfaceColors;
    final isDark = context.isDarkMode;
    final locale = Localizations.localeOf(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: 64,
          padding: const EdgeInsets.symmetric(
            horizontal: ThemeDimensions.marginMobile,
          ),
          decoration: BoxDecoration(
            color: isDark
                ? ThemeColors.darkCanvas.withValues(alpha: 0.95)
                : ThemeColors.surfaceContainerLowest.withValues(alpha: 0.95),
            border: Border(
              bottom: BorderSide(
                color: isDark
                    ? ThemeColors.darkBorder
                    : ThemeColors.slate200.withValues(alpha: 0.8),
              ),
            ),
            boxShadow: const [
              BoxShadow(
                color: Color(0x0A000000),
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1280),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: ThemeColors.stitchPrimary,
                          borderRadius: BorderRadius.circular(9),
                          boxShadow: const [
                            BoxShadow(
                              color: ThemeColors.stitchShadowPrimary,
                              blurRadius: 6,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.monitor_heart_rounded,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'NutriVision',
                            style: TextStyle(
                              fontFamily: ThemeTextStyles.headingFamilyFor(
                                locale,
                              ),
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: surfaces.textPrimary,
                              letterSpacing: -0.4,
                              height: 1.1,
                            ),
                          ),
                          const SizedBox(height: 1),
                          Text(
                            locale.languageCode == 'ar'
                                ? 'الذكاء الإكلينيكي المتقدم'
                                : 'CLINICAL INTELLIGENCE',
                            style: const TextStyle(
                              fontSize: 9.5,
                              fontWeight: FontWeight.w700,
                              color: ThemeColors.stitchPrimaryContainer,
                              letterSpacing: 1.2,
                              height: 1.1,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      InkWell(
                        onTap: () {
                          final current = locale.languageCode;
                          context.read<LocaleCubit>().changeLocale(
                            current == 'ar'
                                ? const Locale('en')
                                : const Locale('ar'),
                          );
                        },
                        borderRadius: BorderRadius.circular(999),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: isDark
                                ? ThemeColors.darkSurface2
                                : ThemeColors.stitchSurfaceContainerLow,
                            borderRadius: BorderRadius.circular(999),
                            border: Border.all(
                              color: isDark
                                  ? ThemeColors.darkBorder
                                  : ThemeColors.slate200,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.language_rounded,
                                size: 16,
                                color: surfaces.textSecondary,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                locale.languageCode == 'ar'
                                    ? 'English'
                                    : 'العربية',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: surfaces.textPrimary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),

                      IconButton(
                        onPressed: () =>
                            context.read<ThemeCubit>().toggleTheme(),
                        icon: Icon(
                          isDark
                              ? Icons.dark_mode_rounded
                              : Icons.light_mode_rounded,
                          size: 19,
                          color: surfaces.textSecondary,
                        ),
                        style: IconButton.styleFrom(
                          backgroundColor: isDark
                              ? ThemeColors.darkSurface2
                              : ThemeColors.stitchSurfaceContainerLow,
                          shape: const CircleBorder(),
                          padding: const EdgeInsets.all(8),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),

        if (showSimulatorDeck)
          Container(
            height: 40,
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: ThemeDimensions.marginMobile,
            ),
            decoration: BoxDecoration(
              color: isDark
                  ? const Color(0xFF0D1829)
                  : ThemeColors.stitchSurfaceContainerHigh,
              border: Border(
                bottom: BorderSide(
                  color: isDark
                      ? ThemeColors.darkBorder
                      : ThemeColors.stitchSurfaceContainerHighest.withValues(
                          alpha: 0.7,
                        ),
                ),
              ),
            ),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1280),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: ThemeColors.stitchPrimaryContainer.withValues(
                            alpha: 0.15,
                          ),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 6,
                              height: 6,
                              decoration: const BoxDecoration(
                                color: ThemeColors.stitchPrimaryContainer,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 6),
                            const Text(
                              'SYS-SIM',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: ThemeColors.stitchPrimary,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Telemetry Sandbox v2.4',
                        style: TextStyle(
                          fontSize: 11,
                          color: surfaces.textMuted,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 14),
                      if (onMetricSelected != null)
                        _SimButton(
                          label: 'Metric',
                          onTap: onMetricSelected!,
                          isDark: isDark,
                        ),
                      if (onImperialSelected != null)
                        _SimButton(
                          label: 'Imperial',
                          onTap: onImperialSelected!,
                          isDark: isDark,
                        ),
                      if (onToggleAlert != null)
                        _SimButton(
                          label: 'Validation Alert',
                          onTap: onToggleAlert!,
                          isDark: isDark,
                        ),
                      _SimButton(
                        label: locale.languageCode == 'ar'
                            ? 'English'
                            : 'العربية (RTL)',
                        onTap: () {
                          context.read<LocaleCubit>().changeLocale(
                            locale.languageCode == 'ar'
                                ? const Locale('en')
                                : const Locale('ar'),
                          );
                        },
                        isDark: isDark,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _SimButton extends StatelessWidget {
  const _SimButton({
    required this.label,
    required this.onTap,
    required this.isDark,
  });

  final String label;
  final VoidCallback onTap;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 6),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(6),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: isDark
                ? ThemeColors.darkSurface2
                : ThemeColors.stitchSurfaceContainerLowest,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(
              color: isDark
                  ? ThemeColors.darkBorder
                  : ThemeColors.stitchSurfaceContainerHighest.withValues(
                      alpha: 0.5,
                    ),
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: isDark
                  ? ThemeColors.darkTextSecondary
                  : ThemeColors.onSurfaceVariant,
            ),
          ),
        ),
      ),
    );
  }
}
