import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nutri_vision/core/extensions/context_extensions.dart';
import 'package:nutri_vision/core/localization/locale_cubit.dart';
import 'package:nutri_vision/core/theme/theme_colors.dart';
import 'package:nutri_vision/core/theme/theme_cubit.dart';
import 'package:nutri_vision/core/theme/theme_dimensions.dart';
import 'package:nutri_vision/core/theme/theme_extensions.dart';
import 'package:nutri_vision/core/theme/theme_text_styles.dart';

class OnboardingHeader extends StatelessWidget {
  const OnboardingHeader({super.key, required this.isDark});

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final surfaces = context.surfaceColors;
    final locale = Localizations.localeOf(context);
    final isWide = context.screenWidth >= 768;

    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(
        horizontal: ThemeDimensions.marginMobile,
      ),
      decoration: BoxDecoration(
        color: isDark
            ? surfaces.level1.withValues(alpha: 0.95)
            : ThemeColors.stitchSurfaceContainerLowest.withValues(alpha: 0.92),
        border: Border(
          bottom: BorderSide(
            color: isDark
                ? surfaces.border
                : ThemeColors.stitchSurfaceContainerHighest.withValues(
                    alpha: 0.4,
                  ),
          ),
        ),
        boxShadow: const [
          BoxShadow(
            color: ThemeColors.stitchShadow,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1100),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: const BoxDecoration(
                      color: ThemeColors.stitchPrimary,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      boxShadow: [
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
                        color: ThemeColors.stitchSurfaceContainerLowest,
                        size: 20,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    context.tr('appName'),
                    style: TextStyle(
                      fontFamily: ThemeTextStyles.headingFamilyFor(locale),
                      fontSize: 19,
                      fontWeight: FontWeight.w700,
                      color: surfaces.textPrimary,
                      letterSpacing: -0.3,
                    ),
                  ),
                ],
              ),

              if (isWide)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _HeaderNavLink(
                      label: context.tr('navOverview'),
                      isActive: true,
                    ),
                    const SizedBox(width: 20),
                    _HeaderNavLink(
                      label: context.tr('navDietaryPlan'),
                      isActive: false,
                    ),
                    const SizedBox(width: 20),
                    _HeaderNavLink(
                      label: context.tr('navTelemetryGoals'),
                      isActive: false,
                    ),
                    const SizedBox(width: 20),
                    _HeaderNavLink(
                      label: context.tr('navPreferences'),
                      isActive: false,
                    ),
                  ],
                ),

              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: isDark
                          ? surfaces.level2
                          : ThemeColors.stitchSurfaceContainerLow,
                      borderRadius: ThemeDimensions.borderRadiusPill,
                      border: Border.all(
                        color: isDark
                            ? surfaces.border
                            : ThemeColors.stitchSurfaceContainerHighest
                                  .withValues(alpha: 0.5),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        InkWell(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(999),
                          ),
                          onTap: () {
                            final current = Localizations.localeOf(context);
                            final next = current.languageCode == 'ar'
                                ? const Locale('en')
                                : const Locale('ar');
                            context.read<LocaleCubit>().changeLocale(next);
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.translate_rounded,
                                  size: 14,
                                  color: surfaces.textSecondary,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'EN / AR',
                                  style: TextStyle(
                                    fontFamily: ThemeTextStyles.fontFamilyFor(
                                      locale,
                                    ),
                                    fontWeight: FontWeight.w700,
                                    fontSize: 11,
                                    color: surfaces.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        Container(
                          width: 1,
                          height: 14,
                          margin: const EdgeInsets.symmetric(horizontal: 2),
                          color: surfaces.border,
                        ),

                        IconButton(
                          iconSize: 16,
                          padding: const EdgeInsets.all(6),
                          constraints: const BoxConstraints(),
                          onPressed: () {
                            context.read<ThemeCubit>().toggleTheme();
                          },
                          icon: Icon(
                            isDark
                                ? Icons.light_mode_rounded
                                : Icons.dark_mode_outlined,
                            color: surfaces.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 10),

                  Container(
                    width: 34,
                    height: 34,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: ThemeColors.stitchPrimary,
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.person_rounded,
                        color: ThemeColors.stitchSurfaceContainerLowest,
                        size: 19,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HeaderNavLink extends StatelessWidget {
  const _HeaderNavLink({required this.label, required this.isActive});
  final String label;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context);

    return Text(
      label,
      style: TextStyle(
        fontFamily: ThemeTextStyles.fontFamilyFor(locale),
        color: isActive
            ? ThemeColors.stitchPrimary
            : context.surfaceColors.textSecondary,
        fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
        fontSize: 13,
      ),
    );
  }
}
