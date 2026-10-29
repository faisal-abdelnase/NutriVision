import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nutri_vision/core/routing/route_names.dart';
import 'package:nutri_vision/core/extensions/context_extensions.dart';
import 'package:nutri_vision/core/responsive/breakpoints.dart';
import 'package:nutri_vision/core/responsive/responsive_text.dart';
import 'package:nutri_vision/core/theme/theme_dimensions.dart';
import 'package:nutri_vision/core/theme/theme_extensions.dart';
import '../../../../core/localization/locale_cubit.dart';
import '../../../../core/theme/theme_cubit.dart';
import '../widgets/auth_widgets.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';

/// Password reset screen connected to the application's auth cubit.
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
    final authState = context.watch<AuthCubit>().state;
    final isLoading = widget.isLoading || authState is AuthLoading;
    final emailSent = widget.emailSent || authState is AuthPasswordResetSent;

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed:
              widget.onBackPressed ?? () => Navigator.of(context).maybePop(),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: SingleChildScrollView(
              padding: EdgeInsetsDirectional.all(
                ThemeBreakpoints.marginFor(context.screenWidth),
              ),
              child: emailSent
                  ? _SentView(
                      bp: bp,
                      onBackToLogin:
                          widget.onBackToLoginPressed ??
                          () => Navigator.of(
                            context,
                          ).pushReplacementNamed(RouteNames.login),
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [

                         // ── Top bar ──
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        constraints: const BoxConstraints(
                          minWidth: ThemeDimensions.touchTarget,
                          minHeight: ThemeDimensions.touchTarget,
                        ),
                        onPressed: (){
                          context.read<ThemeCubit>().toggleTheme();
                        },
                        icon: Icon(
                          context.isDarkMode
                              ? Icons.light_mode_outlined
                              : Icons.dark_mode_outlined,
                          color: primary,
                        ),
                      ),
                      TextButton.icon(
                        style: TextButton.styleFrom(
                          minimumSize: const Size(
                            ThemeDimensions.touchTarget,
                            ThemeDimensions.touchTarget,
                          ),
                        ),
                        onPressed: () { 
                          String local = context.read<LocaleCubit>().state.languageCode == 'en' ? 'ar' : 'en';
                          context.read<LocaleCubit>().changeLocale(Locale(local)); 
                          },
                        icon: Icon(Icons.translate, size: 18, color: primary),
                        label: AppText(
                          context.tr('splashLanguage'),
                          baseFontSize: 14,
                          breakpoint: bp,
                          style: context.textTheme.labelLarge!.copyWith(
                            color: primary,
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: ThemeDimensions.spaceLg),
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
                        AuthHeading(
                          title: context.tr('authForgotTitle'),
                          subtitle: context.tr('authForgotSubtitle'),
                        ),
                        if (authState is AuthError)
                          AuthErrorMessage(message: authState.message),
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
                        AuthSubmitButton(
                          label: context.tr('authSendResetLink'),
                          isLoading: isLoading,
                          onPressed: () {
                            final email = _emailController.text.trim();
                            if (widget.onSendPressed != null) {
                              widget.onSendPressed!(email);
                            } else {
                              context.read<AuthCubit>().sendPasswordResetEmail(
                                email: email,
                              );
                            }
                          },
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
                            onPressed:
                                widget.onBackToLoginPressed ??
                                () => Navigator.of(
                                  context,
                                ).pushReplacementNamed(RouteNames.login),
                            icon: Icon(
                              Icons.arrow_back,
                              size: 18,
                              color: primary,
                            ),
                            label: AppText(
                              context.tr('authBackToLogin'),
                              baseFontSize: 14,
                              breakpoint: bp,
                              style: context.textTheme.labelLarge!.copyWith(
                                color: primary,
                              ),
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
          style: context.textTheme.headlineMedium!.copyWith(
            color: s.textPrimary,
          ),
        ),
        const SizedBox(height: ThemeDimensions.spaceSm),
        AppText(
          context.tr('authResetSentBody'),
          baseFontSize: 14,
          breakpoint: bp,
          textAlign: TextAlign.center,
          style: context.textTheme.bodyMedium!.copyWith(color: s.textSecondary),
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
