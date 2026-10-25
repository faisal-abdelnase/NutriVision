import 'package:flutter/material.dart';
import 'package:nutri_vision/core/extensions/context_extensions.dart';
import 'package:nutri_vision/core/responsive/responsive_text.dart';
import 'package:nutri_vision/core/theme/theme_dimensions.dart';
import 'package:nutri_vision/core/theme/theme_extensions.dart';

/// Splash UI only. Navigation / init logic is wired later by the team.
class SplashScreen extends StatelessWidget {
  const SplashScreen({
    super.key,
    this.onThemeTap,
    this.onLanguageTap,
    this.appVersion = '1.0.0',
  });

  final VoidCallback? onThemeTap;
  final VoidCallback? onLanguageTap;
  final String appVersion;

  @override
  Widget build(BuildContext context) {
    final s = context.surfaceColors;
    final bp = context.breakpoint;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: CustomScrollView(
              slivers: [
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Padding(
                    padding: const EdgeInsetsDirectional.all(
                      ThemeDimensions.margin,
                    ),
                    child: Column(
                      children: [
                        // ── Top bar: theme + language ──
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              constraints: const BoxConstraints(
                                minWidth: ThemeDimensions.touchTarget,
                                minHeight: ThemeDimensions.touchTarget,
                              ),
                              onPressed: onThemeTap,
                              icon: Icon(
                                context.isDarkMode
                                    ? Icons.light_mode_outlined
                                    : Icons.dark_mode_outlined,
                                color: context.colorScheme.primary,
                              ),
                            ),
                            TextButton.icon(
                              style: TextButton.styleFrom(
                                minimumSize: const Size(
                                  ThemeDimensions.touchTarget,
                                  ThemeDimensions.touchTarget,
                                ),
                              ),
                              onPressed: onLanguageTap,
                              icon: Icon(
                                Icons.translate,
                                size: 18,
                                color: context.colorScheme.primary,
                              ),
                              label: AppText(
                                context.tr('splashLanguage'),
                                baseFontSize: 14,
                                breakpoint: bp,
                                style: context.textTheme.labelLarge!.copyWith(
                                  color: context.colorScheme.primary,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const Spacer(),

                        // ── Logo ──
                        Container(
                          width: 112,
                          height: 112,
                          decoration: BoxDecoration(
                            color: s.level1,
                            borderRadius: ThemeDimensions.borderRadiusCard,
                            border: Border.all(color: s.border),
                            boxShadow: s.cardShadow,
                          ),
                          child: Icon(
                            Icons.restaurant_menu_rounded,
                            size: 56,
                            color: context.colorScheme.primary,
                          ),
                        ),
                        const SizedBox(height: ThemeDimensions.spaceLg),

                        // ── App name ──
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            AppText(
                              'Nutri',
                              baseFontSize: 32,
                              breakpoint: bp,
                              style: context.textTheme.headlineMedium!
                                  .copyWith(color: s.textPrimary),
                            ),
                            AppText(
                              'Vision',
                              baseFontSize: 32,
                              breakpoint: bp,
                              style: context.textTheme.headlineMedium!
                                  .copyWith(color: context.colorScheme.primary),
                            ),
                          ],
                        ),
                        const SizedBox(height: ThemeDimensions.spaceSm),

                        // ── Tagline chip ──
                        Container(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                            ThemeDimensions.space12,
                            ThemeDimensions.spaceXs,
                            ThemeDimensions.space12,
                            ThemeDimensions.spaceXs,
                          ),
                          decoration: BoxDecoration(
                            color: s.level2,
                            borderRadius: ThemeDimensions.borderRadiusPill,
                            border: Border.all(color: s.border),
                          ),
                          child: AppText(
                            context.tr('splashTagline'),
                            baseFontSize: 12,
                            breakpoint: bp,
                            style: context.textTheme.labelMedium!.copyWith(
                              color: s.textSecondary,
                            ),
                          ),
                        ),
                        const SizedBox(height: ThemeDimensions.spaceMd),

                        // ── Description ──
                        AppText(
                          context.tr('splashDescription'),
                          baseFontSize: 16,
                          breakpoint: bp,
                          textAlign: TextAlign.center,
                          style: context.textTheme.bodyLarge!.copyWith(
                            color: s.textPrimary,
                          ),
                        ),
                        const SizedBox(height: ThemeDimensions.space40),

                        // ── Loading ──
                        ClipRRect(
                          borderRadius: ThemeDimensions.borderRadiusPill,
                          child: const LinearProgressIndicator(minHeight: 6),
                        ),
                        const SizedBox(height: ThemeDimensions.space12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.sync, size: 16, color: s.textMuted),
                            const SizedBox(width: ThemeDimensions.spaceXs),
                            AppText(
                              context.tr('splashLoading'),
                              baseFontSize: 12,
                              breakpoint: bp,
                              style: context.textTheme.bodySmall!.copyWith(
                                color: s.textMuted,
                              ),
                            ),
                          ],
                        ),

                        const Spacer(),

                        // ── Footer ──
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.verified_user_outlined,
                              size: 16,
                              color: context.statusColors.success,
                            ),
                            const SizedBox(width: ThemeDimensions.spaceXs),
                            Flexible(
                              child: AppText(
                                context.tr('splashSecure'),
                                baseFontSize: 12,
                                breakpoint: bp,
                                textAlign: TextAlign.center,
                                style: context.textTheme.bodySmall!.copyWith(
                                  color: s.textSecondary,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: ThemeDimensions.spaceXs),
                        AppText(
                          'v$appVersion',
                          baseFontSize: 12,
                          breakpoint: bp,
                          style: context.textTheme.bodySmall!.copyWith(
                            color: s.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}