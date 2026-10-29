import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nutri_vision/core/extensions/context_extensions.dart';
import 'package:nutri_vision/core/responsive/responsive_text.dart';
import 'package:nutri_vision/core/theme/theme_dimensions.dart';
import 'package:nutri_vision/core/theme/theme_extensions.dart';
import 'package:nutri_vision/core/routing/route_names.dart';
import '../../../../core/localization/locale_cubit.dart';
import '../../../../core/theme/theme_cubit.dart';
import '../widgets/auth_widgets.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';
import 'forgot_password_screen.dart';

/// Login screen connected to the application's Firebase authentication cubit.
class LoginScreen extends StatefulWidget {
  const LoginScreen({
    super.key,
    this.onLoginPressed,
    this.onGooglePressed,
    this.onForgotPasswordPressed,
    this.onSignUpPressed,
    this.isLoading = false,
  });

  /// Called with (email, password, rememberMe).
  final void Function(String email, String password, bool rememberMe)?
  onLoginPressed;
  final VoidCallback? onGooglePressed;
  final VoidCallback? onForgotPasswordPressed;
  final VoidCallback? onSignUpPressed;
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
    final authState = context.watch<AuthCubit>().state;
    final isLoading = widget.isLoading || authState is AuthLoading;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: SingleChildScrollView(
              padding: EdgeInsetsDirectional.all(
                ThemeBreakpoints.marginFor(context.screenWidth),
              ),
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
                  AuthHeading(
                    title: context.tr('authWelcomeBack'),
                    subtitle: context.tr('authLoginSubtitle'),
                  ),
                  if (authState is AuthError)
                    AuthErrorMessage(message: authState.message),
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
                        onPressed:
                            widget.onForgotPasswordPressed ??
                            () => Navigator.of(context).push(
                              MaterialPageRoute<void>(
                                builder: (_) => const ForgotPasswordScreen(),
                              ),
                            ),
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
                  AuthSubmitButton(
                    label: context.tr('authLogin'),
                    isLoading: isLoading,
                    onPressed: () {
                      final email = _emailController.text.trim();
                      if (widget.onLoginPressed != null) {
                        widget.onLoginPressed!(
                          email,
                          _passwordController.text,
                          _rememberMe,
                        );
                      } else {
                        context.read<AuthCubit>().signIn(
                          email: email,
                          password: _passwordController.text,
                        );
                      }
                    },
                  ),
                  const SizedBox(height: ThemeDimensions.spaceLg),

                  // ── Divider ──
                  const AuthDivider(),
                  const SizedBox(height: ThemeDimensions.spaceMd),

                  // ── Google ──
                  AuthGoogleButton(onPressed: widget.onGooglePressed),
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
                        onPressed:
                            widget.onSignUpPressed ??
                            () => Navigator.of(
                              context,
                            ).pushNamed(RouteNames.authentication),
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
