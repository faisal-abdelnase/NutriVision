import 'package:flutter/material.dart';
import 'package:nutri_vision/core/extensions/context_extensions.dart';
import 'package:nutri_vision/core/responsive/breakpoints.dart';
import 'package:nutri_vision/core/responsive/responsive_text.dart';
import 'package:nutri_vision/core/theme/theme_dimensions.dart';
import 'package:nutri_vision/core/theme/theme_extensions.dart';

/// Forgot Password UI only. Sending logic is wired later by the team.
class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({
    super.key,
    this.onSendPressed,
    this.onBackToLoginPressed,
    this.onBackPressed,
    this.isLoading = false,
    this.emailSent = false,
  });

  /// Called with the entered email.
  final void Function(String email)? onSendPressed;
  final VoidCallback? onBackToLoginPressed;
  final VoidCallback? onBackPressed;
  final bool isLoading;

  /// When true, shows the "check your email" confirmation instead of the form.
  final bool emailSent;

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = context.surfaceColors;
    final bp = context.breakpoint;
    final primary = context.colorScheme.primary;

    return Scaffold(
      appBar: AppBar(leading: BackButton(onPressed: widget.onBackPressed)),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: SingleChildScrollView(
              padding: const EdgeInsetsDirectional.all(ThemeDimensions.margin),
              child: widget.emailSent
                  ? _SentView(
                      bp: bp,
                      onBackToLogin: widget.onBackToLoginPressed,
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // ── Icon ──
                        Center(
                          child: Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              color: s.level2,
                              borderRadius: ThemeDimensions.borderRadiusCard,
                              border: Border.all(color: s.border),
                            ),
                            child: Icon(
                              Icons.lock_reset,
                              size: 40,
                              color: primary,
                            ),
                          ),
                        ),
                        const SizedBox(height: ThemeDimensions.spaceLg),

                        // ── Title + subtitle ──
                        AppText(
                          context.tr('authForgotTitle'),
                          baseFontSize: 28,
                          breakpoint: bp,
                          textAlign: TextAlign.center,
                          style: context.textTheme.headlineMedium!
                              .copyWith(color: s.textPrimary),
                        ),
                        const SizedBox(height: ThemeDimensions.spaceSm),
                        AppText(
                          context.tr('authForgotSubtitle'),
                          baseFontSize: 14,
                          breakpoint: bp,
                          textAlign: TextAlign.center,
                          style: context.textTheme.bodyMedium!
                              .copyWith(color: s.textSecondary),
                        ),
                        const SizedBox(height: ThemeDimensions.spaceLg),

                        // ── Email ──
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.done,
                          autofillHints: const [AutofillHints.email],
                          decoration: InputDecoration(
                            labelText: context.tr('authEmail'),
                            hintText: context.tr('authEmailHint'),
                            prefixIcon: const Icon(Icons.mail_outline),
                          ),
                        ),
                        const SizedBox(height: ThemeDimensions.spaceLg),

                        // ── Send button ──
                        ElevatedButton(
                          onPressed: widget.isLoading
                              ? null
                              : () => widget.onSendPressed
                                  ?.call(_emailController.text.trim()),
                          child: widget.isLoading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : Text(context.tr('authSendResetLink')),
                        ),
                        const SizedBox(height: ThemeDimensions.spaceMd),

                        // ── Back to login ──
                        Center(
                          child: TextButton.icon(
                            style: TextButton.styleFrom(
                              minimumSize: const Size(
                                ThemeDimensions.touchTarget,
                                ThemeDimensions.touchTarget,
                              ),
                            ),
                            onPressed: widget.onBackToLoginPressed,
                            icon: Icon(
                              Icons.arrow_back,
                              size: 18,
                              color: primary,
                            ),
                            label: AppText(
                              context.tr('authBackToLogin'),
                              baseFontSize: 14,
                              breakpoint: bp,
                              style: context.textTheme.labelLarge!
                                  .copyWith(color: primary),
                            ),
                          ),
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

class _SentView extends StatelessWidget {
  const _SentView({required this.bp, required this.onBackToLogin});

  final AppBreakpoint bp;
  final VoidCallback? onBackToLogin;

  @override
  Widget build(BuildContext context) {
    final s = context.surfaceColors;
    final status = context.statusColors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Center(
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: status.successContainer,
              borderRadius: ThemeDimensions.borderRadiusCard,
            ),
            child: Icon(
              Icons.mark_email_read_outlined,
              size: 40,
              color: status.onSuccessContainer,
            ),
          ),
        ),
        const SizedBox(height: ThemeDimensions.spaceLg),
        AppText(
          context.tr('authResetSentTitle'),
          baseFontSize: 28,
          breakpoint: bp,
          textAlign: TextAlign.center,
          style: context.textTheme.headlineMedium!
              .copyWith(color: s.textPrimary),
        ),
        const SizedBox(height: ThemeDimensions.spaceSm),
        AppText(
          context.tr('authResetSentBody'),
          baseFontSize: 14,
          breakpoint: bp,
          textAlign: TextAlign.center,
          style: context.textTheme.bodyMedium!
              .copyWith(color: s.textSecondary),
        ),
        const SizedBox(height: ThemeDimensions.spaceLg),
        ElevatedButton(
          onPressed: onBackToLogin,
          child: Text(context.tr('authBackToLogin')),
        ),
      ],
    );
  }
}