import 'package:flutter/material.dart';
import 'package:nutri_vision/core/extensions/context_extensions.dart';
import 'package:nutri_vision/core/theme/theme_colors.dart';
import 'package:nutri_vision/core/theme/theme_extensions.dart';
import 'package:nutri_vision/core/theme/theme_text_styles.dart';
import 'onboarding_page_indicator.dart';

class OnboardingFooter extends StatelessWidget {
  const OnboardingFooter({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.onDotTap,
    required this.isDark,
  });

  final int currentPage;
  final int totalPages;
  final ValueChanged<int> onDotTap;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final surfaces = context.surfaceColors;
    final locale = Localizations.localeOf(context);

    return Wrap(
      alignment: WrapAlignment.spaceBetween,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 16,
      runSpacing: 12,
      children: [
        OnboardingPageIndicator(
          pageCount: totalPages,
          pageIndex: currentPage,
          onDotTap: onDotTap,
        ),

        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.info_outline_rounded,
              size: 15,
              color: ThemeColors.stitchPrimary,
            ),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                context.tr('onboardingDisclaimer'),
                style: TextStyle(
                  fontFamily: ThemeTextStyles.fontFamilyFor(locale),
                  color: surfaces.textMuted,
                  fontSize: 11,
                  height: 1.3,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
