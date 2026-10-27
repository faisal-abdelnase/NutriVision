import 'package:flutter/material.dart';
import 'package:nutri_vision/core/constants/asset_paths.dart';
import 'package:nutri_vision/core/extensions/context_extensions.dart';
import 'package:nutri_vision/core/theme/theme_colors.dart';
import 'package:nutri_vision/core/theme/theme_dimensions.dart';
import 'package:nutri_vision/core/theme/theme_text_styles.dart';
import '../components/asset_or_fallback_food_image.dart';
import '../components/dashed_rect_painter.dart';
import 'onboarding_illustration_card.dart';

class Slide2ViewfinderCard extends StatelessWidget {
  const Slide2ViewfinderCard({
    super.key,
    required this.pulse,
    required this.ping,
    required this.spin,
    required this.isDark,
  });

  final Animation<double> pulse;
  final Animation<double> ping;
  final AnimationController spin;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return OnboardingIllustrationCard(
      child: Column(
        children: [
          _CameraViewfinderHUD(ping: ping, spin: spin, isDark: isDark),

          const SizedBox(height: 12),

          _NutriVisionSwapAdviceCard(isDark: isDark),
        ],
      ),
    );
  }
}

class _CameraViewfinderHUD extends StatelessWidget {
  const _CameraViewfinderHUD({
    required this.ping,
    required this.spin,
    required this.isDark,
  });

  final Animation<double> ping;
  final AnimationController spin;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.all(Radius.circular(18)),
      child: SizedBox(
        height: 200,
        width: double.infinity,
        child: Stack(
          fit: StackFit.expand,
          children: [
            const AssetOrFallbackFoodImage(
              assetPath: AssetPaths.onboardingSourdoughToast,
              fallbackGradient: [
                ThemeColors.slate800,
                ThemeColors.slate700,
                ThemeColors.slate600,
              ],
              fallbackIcon: Icons.camera_alt_rounded,
            ),

            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    ThemeColors.stitchScrim,
                    Colors.transparent,
                    ThemeColors.stitchPrimaryDark,
                  ],
                ),
              ),
            ),

            PositionedDirectional(
              top: 12,
              start: 12,
              end: 12,
              child: _ViewfinderTopHUD(spin: spin),
            ),

            Center(child: _ViewfinderReticle(ping: ping)),

            const PositionedDirectional(
              bottom: 12,
              start: 14,
              end: 14,
              child: _ViewfinderBottomHUD(),
            ),
          ],
        ),
      ),
    );
  }
}

class _ViewfinderTopHUD extends StatelessWidget {
  const _ViewfinderTopHUD({required this.spin});

  final AnimationController spin;

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            RotationTransition(
              turns: spin,
              child: const Icon(
                Icons.blur_on_rounded,
                size: 18,
                color: ThemeColors.stitchPrimaryContainer,
              ),
            ),
            const SizedBox(width: 6),
            Text(
              context.tr('bioScanActive'),
              style: TextStyle(
                fontFamily: ThemeTextStyles.fontFamilyFor(locale),
                color: ThemeColors.stitchTextOnDarkSecondary,
                fontWeight: FontWeight.w700,
                fontSize: 11,
                letterSpacing: 1.0,
              ),
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: const BoxDecoration(
            color: ThemeColors.stitchPrimary,
            borderRadius: BorderRadius.all(Radius.circular(6)),
          ),
          child: Text(
            context.tr('matchPct'),
            style: TextStyle(
              fontFamily: ThemeTextStyles.fontFamilyFor(locale),
              color: ThemeColors.stitchSurfaceContainerLowest,
              fontWeight: FontWeight.w700,
              fontSize: 11,
            ),
          ),
        ),
      ],
    );
  }
}

class _ViewfinderReticle extends StatelessWidget {
  const _ViewfinderReticle({required this.ping});

  final Animation<double> ping;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      height: 100,
      child: CustomPaint(
        painter: DashedRectPainter(
          color: ThemeColors.stitchPrimaryContainer.withValues(alpha: 0.8),
          radius: 14,
          dashLength: 8,
          dashGap: 5,
        ),
        child: Center(
          child: AnimatedBuilder(
            animation: ping,
            builder: (context, _) {
              return Container(
                width: 16 * ping.value,
                height: 16 * ping.value,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: ThemeColors.stitchPrimaryContainer.withValues(
                    alpha: 1.0 - ping.value * 0.7,
                  ),
                  border: Border.all(
                    color: ThemeColors.stitchPrimaryContainer,
                    width: 2,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _ViewfinderBottomHUD extends StatelessWidget {
  const _ViewfinderBottomHUD();

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                context.tr('identifiedFood'),
                style: TextStyle(
                  fontFamily: ThemeTextStyles.fontFamilyFor(locale),
                  color: ThemeColors.stitchPrimaryContainer,
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                context.tr('glycemicWarning'),
                style: TextStyle(
                  fontFamily: ThemeTextStyles.fontFamilyFor(locale),
                  color: ThemeColors.stitchSurfaceContainerLowest.withValues(
                    alpha: 0.85,
                  ),
                  fontSize: 10,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        const Icon(
          Icons.warning_amber_rounded,
          size: 22,
          color: ThemeColors.stitchAmberAlert,
        ),
      ],
    );
  }
}

class _NutriVisionSwapAdviceCard extends StatelessWidget {
  const _NutriVisionSwapAdviceCard({required this.isDark});
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark
            ? ThemeColors.stitchSwapCardBgDark
            : ThemeColors.stitchSecondaryFixed.withValues(alpha: 0.28),
        borderRadius: const BorderRadius.all(Radius.circular(16)),
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
                    Container(
                      width: 26,
                      height: 26,
                      decoration: const BoxDecoration(
                        color: ThemeColors.stitchSecondary,
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.auto_awesome,
                          size: 15,
                          color: ThemeColors.stitchSurfaceContainerLowest,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        context.tr('swapAdviceTitle'),
                        style: TextStyle(
                          fontFamily: ThemeTextStyles.headingFamilyFor(locale),
                          color: isDark
                              ? ThemeColors.stitchSecondaryContainer
                              : ThemeColors.stitchOnSecondaryFixed,
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: const BoxDecoration(
                  color: ThemeColors.stitchPrimary,
                  borderRadius: ThemeDimensions.borderRadiusPill,
                ),
                child: Text(
                  context.tr('swapScore'),
                  style: TextStyle(
                    fontFamily: ThemeTextStyles.fontFamilyFor(locale),
                    color: ThemeColors.stitchSurfaceContainerLowest,
                    fontWeight: FontWeight.w700,
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          Row(
            children: [
              Expanded(
                child: _SwapComparisonTile(
                  icon: Icons.remove_circle_outline,
                  iconColor: ThemeColors.stitchTertiary,
                  title: context.tr('swapFrom'),
                  titleColor: ThemeColors.stitchTertiary,
                  stats: context.tr('slide2SwapFromStats'),
                  statsColor: ThemeColors.slate400,
                  backgroundColor: isDark
                      ? ThemeColors.stitchDarkCardSurface
                      : ThemeColors.stitchSurfaceContainer.withValues(
                          alpha: 0.7,
                        ),
                  isStrikethrough: true,
                ),
              ),

              const SizedBox(width: 8),

              Expanded(
                child: _SwapComparisonTile(
                  icon: Icons.check_circle_rounded,
                  iconColor: ThemeColors.stitchPrimary,
                  title: context.tr('swapTo'),
                  titleColor: ThemeColors.stitchPrimary,
                  stats: context.tr('slide2SwapToStats'),
                  statsColor: isDark
                      ? ThemeColors.stitchSurfaceContainerLowest
                      : ThemeColors.stitchPrimaryDark,
                  statsWeight: FontWeight.w700,
                  backgroundColor: isDark
                      ? ThemeColors.stitchDarkCardSurface
                      : ThemeColors.stitchSurfaceContainerLowest,
                  border: Border.all(
                    color: ThemeColors.stitchPrimaryContainer.withValues(
                      alpha: 0.4,
                    ),
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: ThemeColors.stitchShadow,
                      blurRadius: 6,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          Text(
            context.tr('swapReasoning'),
            style: TextStyle(
              fontFamily: ThemeTextStyles.fontFamilyFor(locale),
              color: isDark
                  ? ThemeColors.stitchTextOnDarkMuted
                  : ThemeColors.stitchOnSecondaryFixedVariant,
              fontSize: 11,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

class _SwapComparisonTile extends StatelessWidget {
  const _SwapComparisonTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.titleColor,
    required this.stats,
    required this.statsColor,
    required this.backgroundColor,
    this.statsWeight,
    this.isStrikethrough = false,
    this.border,
    this.boxShadow,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final Color titleColor;
  final String stats;
  final Color statsColor;
  final Color backgroundColor;
  final FontWeight? statsWeight;
  final bool isStrikethrough;
  final BoxBorder? border;
  final List<BoxShadow>? boxShadow;

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context);

    return Container(
      padding: const EdgeInsets.all(9),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        border: border,
        boxShadow: boxShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 13, color: iconColor),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontFamily: ThemeTextStyles.fontFamilyFor(locale),
                    decoration: isStrikethrough
                        ? TextDecoration.lineThrough
                        : null,
                    color: titleColor,
                    fontWeight: FontWeight.w700,
                    fontSize: 10,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            stats,
            style: TextStyle(
              fontFamily: ThemeTextStyles.fontFamilyFor(locale),
              color: statsColor,
              fontWeight: statsWeight,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}
