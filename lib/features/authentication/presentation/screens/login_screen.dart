import 'package:flutter/material.dart';
import 'package:nutri_vision/core/extensions/context_extensions.dart';
import 'package:nutri_vision/core/responsive/responsive_text.dart';
import 'package:nutri_vision/core/theme/theme_dimensions.dart';
import 'package:nutri_vision/core/theme/theme_extensions.dart';

/// Login UI only. Validation / auth logic is wired later by the team.
class LoginScreen extends StatefulWidget {
  const LoginScreen({
    super.key,
    this.onLoginPressed,
    this.onGooglePressed,
    this.onForgotPasswordPressed,
    this.onSignUpPressed,
    this.onThemeTap,
    this.onLanguageTap,
    this.isLoading = false,
  });

  /// Called with (email, password, rememberMe).
  final void Function(String email, String password, bool rememberMe)?
  onLoginPressed;
  final VoidCallback? onGooglePressed;
  final VoidCallback? onForgotPasswordPressed;
  final VoidCallback? onSignUpPressed;
  final VoidCallback? onThemeTap;
  final VoidCallback? onLanguageTap;
  final bool isLoading;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscure = true;
  bool _rememberMe = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = context.surfaceColors;
    final bp = context.breakpoint;
    final primary = context.colorScheme.primary;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: SingleChildScrollView(
              padding: const EdgeInsetsDirectional.all(ThemeDimensions.margin),
              child: Column(
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
                        onPressed: widget.onThemeTap,
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
                        onPressed: widget.onLanguageTap,
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
                  const SizedBox(height: ThemeDimensions.spaceLg),

                  // ── Logo ──
                  Center(
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: s.level1,
                        borderRadius: ThemeDimensions.borderRadiusCard,
                        border: Border.all(color: s.border),
                        boxShadow: s.cardShadow,
                      ),
                      child: Icon(
                        Icons.restaurant_menu_rounded,
                        size: 40,
                        color: primary,
                      ),
                    ),
                  ),
                  const SizedBox(height: ThemeDimensions.spaceMd),

                  // ── Title + subtitle ──
                  AppText(
                    context.tr('authWelcomeBack'),
                    baseFontSize: 28,
                    breakpoint: bp,
                    textAlign: TextAlign.center,
                    style: context.textTheme.headlineMedium!.copyWith(
                      color: s.textPrimary,
                    ),
                  ),
                  const SizedBox(height: ThemeDimensions.spaceSm),
                  AppText(
                    context.tr('authLoginSubtitle'),
                    baseFontSize: 14,
                    breakpoint: bp,
                    textAlign: TextAlign.center,
                    style: context.textTheme.bodyMedium!.copyWith(
                      color: s.textSecondary,
                    ),
                  ),
                  const SizedBox(height: ThemeDimensions.spaceLg),

                  // ── Email ──
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    autofillHints: const [AutofillHints.email],
                    decoration: InputDecoration(
                      labelText: context.tr('authEmail'),
                      hintText: context.tr('authEmailHint'),
                      prefixIcon: const Icon(Icons.mail_outline),
                    ),
                  ),
                  const SizedBox(height: ThemeDimensions.spaceMd),

                  // ── Password ──
                  TextFormField(
                    controller: _passwordController,
                    obscureText: _obscure,
                    textInputAction: TextInputAction.done,
                    autofillHints: const [AutofillHints.password],
                    decoration: InputDecoration(
                      labelText: context.tr('authPassword'),
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        tooltip: _obscure
                            ? context.tr('authShowPassword')
                            : context.tr('authHidePassword'),
                        onPressed: () => setState(() => _obscure = !_obscure),
                        icon: Icon(
                          _obscure
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: ThemeDimensions.spaceSm),

                  // ── Remember me + forgot ──
                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () =>
                              setState(() => _rememberMe = !_rememberMe),
                          borderRadius: ThemeDimensions.borderRadiusMedium,
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(
                              minHeight: ThemeDimensions.touchTarget,
                            ),
                            child: Row(
                              children: [
                                Checkbox(
                                  value: _rememberMe,
                                  onChanged: (v) =>
                                      setState(() => _rememberMe = v ?? false),
                                ),
                                Flexible(
                                  child: AppText(
                                    context.tr('authRememberMe'),
                                    baseFontSize: 14,
                                    breakpoint: bp,
                                    style: context.textTheme.bodyMedium!
                                        .copyWith(color: s.textSecondary),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      TextButton(
                        style: TextButton.styleFrom(
                          minimumSize: const Size(
                            ThemeDimensions.touchTarget,
                            ThemeDimensions.touchTarget,
                          ),
                        ),
                        onPressed: widget.onForgotPasswordPressed,
                        child: AppText(
                          context.tr('authForgotPassword'),
                          baseFontSize: 14,
                          breakpoint: bp,
                          style: context.textTheme.labelLarge!.copyWith(
                            color: primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: ThemeDimensions.spaceMd),

                  // ── Login button ──
                  ElevatedButton(
                    onPressed: widget.isLoading
                        ? null
                        : () => widget.onLoginPressed?.call(
                            _emailController.text.trim(),
                            _passwordController.text,
                            _rememberMe,
                          ),
                    child: widget.isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Text(context.tr('authLogin')),
                  ),
                  const SizedBox(height: ThemeDimensions.spaceLg),

                  // ── Divider ──
                  Row(
                    children: [
                      Expanded(child: Divider(color: s.border)),
                      Padding(
                        padding: const EdgeInsetsDirectional.symmetric(
                          horizontal: ThemeDimensions.space12,
                        ),
                        child: AppText(
                          context.tr('authOrContinueWith'),
                          baseFontSize: 12,
                          breakpoint: bp,
                          style: context.textTheme.bodySmall!.copyWith(
                            color: s.textMuted,
                          ),
                        ),
                      ),
                      Expanded(child: Divider(color: s.border)),
                    ],
                  ),
                  const SizedBox(height: ThemeDimensions.spaceMd),

                  // ── Google ──
                  OutlinedButton.icon(
                    onPressed: widget.onGooglePressed,
                    icon: const Icon(Icons.g_mobiledata, size: 28),
                    label: Text(context.tr('authContinueWithGoogle')),
                  ),
                  const SizedBox(height: ThemeDimensions.spaceLg),

                  // ── Sign up link ──
                  Wrap(
                    alignment: WrapAlignment.center,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      AppText(
                        context.tr('authNoAccount'),
                        baseFontSize: 14,
                        breakpoint: bp,
                        style: context.textTheme.bodyMedium!.copyWith(
                          color: s.textSecondary,
                        ),
                      ),
                      TextButton(
                        style: TextButton.styleFrom(
                          minimumSize: const Size(
                            ThemeDimensions.touchTarget,
                            ThemeDimensions.touchTarget,
                          ),
                        ),
                        onPressed: widget.onSignUpPressed,
                        child: AppText(
                          context.tr('authCreateAccount'),
                          baseFontSize: 14,
                          breakpoint: bp,
                          style: context.textTheme.labelLarge!.copyWith(
                            color: primary,
                          ),
                        ),
                      ),
                    ],
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
