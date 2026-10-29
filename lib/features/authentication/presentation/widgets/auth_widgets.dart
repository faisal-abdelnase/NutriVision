import 'package:flutter/material.dart';
import 'package:nutri_vision/core/extensions/context_extensions.dart';
import 'package:nutri_vision/core/responsive/responsive_text.dart';
import 'package:nutri_vision/core/theme/theme_dimensions.dart';
import 'package:nutri_vision/core/theme/theme_extensions.dart';

class AuthHeading extends StatelessWidget {
  const AuthHeading({super.key, required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final surfaces = context.surfaceColors;
    return Column(
      children: [
        AppText(
          title,
          baseFontSize: 28,
          breakpoint: context.breakpoint,
          textAlign: TextAlign.center,
          style: context.textTheme.headlineMedium!.copyWith(
            color: surfaces.textPrimary,
          ),
        ),
        const SizedBox(height: ThemeDimensions.spaceSm),
        AppText(
          subtitle,
          baseFontSize: 14,
          breakpoint: context.breakpoint,
          textAlign: TextAlign.center,
          style: context.textTheme.bodyMedium!.copyWith(
            color: surfaces.textSecondary,
          ),
        ),
      ],
    );
  }
}

class AuthDivider extends StatelessWidget {
  const AuthDivider({super.key});

  @override
  Widget build(BuildContext context) {
    final surfaces = context.surfaceColors;
    return Row(
      children: [
        Expanded(child: Divider(color: surfaces.border)),
        Padding(
          padding: const EdgeInsetsDirectional.symmetric(
            horizontal: ThemeDimensions.space12,
          ),
          child: AppText(
            context.tr('authOrContinueWith'),
            baseFontSize: 12,
            breakpoint: context.breakpoint,
            style: context.textTheme.bodySmall!.copyWith(
              color: surfaces.textMuted,
            ),
          ),
        ),
        Expanded(child: Divider(color: surfaces.border)),
      ],
    );
  }
}

class AuthSubmitButton extends StatelessWidget {
  const AuthSubmitButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;

  @override
  Widget build(BuildContext context) => ElevatedButton(
    onPressed: isLoading ? null : onPressed,
    child: isLoading
        ? const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          )
        : Text(label),
  );
}

class AuthGoogleButton extends StatelessWidget {
  const AuthGoogleButton({super.key, this.onPressed});

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) => OutlinedButton.icon(
    onPressed: onPressed,
    icon: const Icon(Icons.g_mobiledata, size: 28),
    label: Text(context.tr('authContinueWithGoogle')),
  );
}

class AuthErrorMessage extends StatelessWidget {
  const AuthErrorMessage({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) => Semantics(
    liveRegion: true,
    child: Container(
      margin: const EdgeInsets.only(top: ThemeDimensions.spaceMd),
      padding: const EdgeInsets.all(ThemeDimensions.spaceMd),
      decoration: BoxDecoration(
        color: context.colorScheme.errorContainer,
        borderRadius: ThemeDimensions.borderRadiusMedium,
      ),
      child: Text(
        message,
        textAlign: TextAlign.center,
        style: context.textTheme.bodyMedium!.copyWith(
          color: context.colorScheme.onErrorContainer,
        ),
      ),
    ),
  );
}
