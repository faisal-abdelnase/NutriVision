import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/routing/route_names.dart';
import '../../../../core/theme/app_button_styles.dart';
import '../../../../core/theme/theme_colors.dart';
import '../../../../core/theme/theme_dimensions.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../../../core/theme/theme_text_styles.dart';
import '../../../onboarding/presentation/cubit/onboarding_cubit.dart';

/// Landing screen shown when arriving at [RouteNames.authentication].
///
/// Confirms onboarding completion and provides a developer/tester friendly
/// way to reset the onboarding state and test the flow repeatedly.
class AuthPlaceholderPage extends StatelessWidget {
  const AuthPlaceholderPage({super.key});

  Future<void> _resetOnboarding(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('onboarding_state');
    if (context.mounted) {
      await context.read<OnboardingCubit>().checkOnboardingStatus();
      if (context.mounted) {
        Navigator.of(
          context,
        ).pushNamedAndRemoveUntil(RouteNames.onboarding, (_) => false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final surfaces = context.surfaceColors;
    final cs = context.colorScheme;

    return Scaffold(
      backgroundColor: cs.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(ThemeDimensions.marginMobile),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Brand Icon Container
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          ThemeColors.primaryDarker,
                          ThemeColors.primary,
                        ],
                      ),
                      borderRadius: ThemeDimensions.borderRadiusCard,
                      boxShadow: [
                        BoxShadow(
                          color: ThemeColors.primary.withValues(alpha: 0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.check_circle_outline,
                        color: Colors.white,
                        size: 44,
                      ),
                    ),
                  ),
                  const SizedBox(height: ThemeDimensions.spaceLg),

                  Text(
                    'NutriVision',
                    style: ThemeTextStyles.headlineMedium.copyWith(
                      color: surfaces.textPrimary,
                      fontFamily: ThemeTextStyles.headingFamilyFor(
                        Localizations.localeOf(context),
                      ),
                    ),
                  ),
                  const SizedBox(height: ThemeDimensions.spaceSm),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: cs.primaryContainer,
                      borderRadius: ThemeDimensions.borderRadiusPill,
                    ),
                    child: Text(
                      'Onboarding Completed Successfully',
                      style: ThemeTextStyles.labelSmall.copyWith(
                        color: cs.onPrimaryContainer,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: ThemeDimensions.spaceMd),

                  Text(
                    context.tr('authenticationNotImplemented'),
                    textAlign: TextAlign.center,
                    style: ThemeTextStyles.bodyMedium.copyWith(
                      color: surfaces.textSecondary,
                    ),
                  ),
                  const SizedBox(height: ThemeDimensions.spaceXl),

                  FilledButton.icon(
                    onPressed: () {
                      Navigator.of(
                        context,
                      ).pushNamed(RouteNames.infoCompletion);
                    },
                    style: FilledButton.styleFrom(
                      backgroundColor: ThemeColors.stitchPrimary,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(
                        260,
                        ThemeDimensions.buttonHeight,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: const Icon(Icons.speed_rounded, size: 18),
                    label: const Text(
                      'Launch Info Completion Screens',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: ThemeDimensions.spaceMd),

                  // Reset Button for Testing Flow
                  OutlinedButton.icon(
                    onPressed: () => _resetOnboarding(context),
                    style: AppButtonStyles.outline(cs).copyWith(
                      minimumSize: const WidgetStatePropertyAll(
                        Size(220, ThemeDimensions.buttonHeight),
                      ),
                    ),
                    icon: const Icon(Icons.refresh, size: 18),
                    label: const Text('Replay Onboarding'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
