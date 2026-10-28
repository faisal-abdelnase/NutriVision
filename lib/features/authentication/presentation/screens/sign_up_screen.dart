import 'package:flutter/material.dart';
import 'package:nutri_vision/core/extensions/context_extensions.dart';
import 'package:nutri_vision/core/responsive/responsive_text.dart';
import 'package:nutri_vision/core/theme/theme_dimensions.dart';
import 'package:nutri_vision/core/theme/theme_extensions.dart';
import 'package:nutri_vision/core/responsive/breakpoints.dart';

/// Sign Up UI only. Validation / auth logic is wired later by the team.
class SignUpScreen extends StatefulWidget {
  const SignUpScreen({
    super.key,
    this.onSignUpPressed,
    this.onGooglePressed,
    this.onLoginPressed,
    this.onBackPressed,
    this.isLoading = false,
  });

  /// Called with (fullName, email, password).
  final void Function(String fullName, String email, String password)?
  onSignUpPressed;
  final VoidCallback? onGooglePressed;
  final VoidCallback? onLoginPressed;
  final VoidCallback? onBackPressed;
  final bool isLoading;

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _obscure = true;
  bool _obscureConfirm = true;
  bool _acceptTerms = false;

  @override
  void initState() {
    super.initState();
    _passwordController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  bool get _hasLength => _passwordController.text.length >= 8;
  bool get _hasUpper => _passwordController.text.contains(RegExp(r'[A-Z]'));
  bool get _hasNumber => _passwordController.text.contains(RegExp(r'[0-9]'));
  bool get _hasSymbol =>
      _passwordController.text.contains(RegExp(r'[^A-Za-z0-9]'));

  int get _score =>
      [_hasLength, _hasUpper, _hasNumber, _hasSymbol].where((e) => e).length;

  @override
  Widget build(BuildContext context) {
    final s = context.surfaceColors;
    final bp = context.breakpoint;
    final primary = context.colorScheme.primary;

    Color strengthColor() {
      if (_score <= 1) return context.statusColors.critical;
      if (_score <= 3) return context.statusColors.warning;
      return context.statusColors.success;
    }

    return Scaffold(
      appBar: AppBar(leading: BackButton(onPressed: widget.onBackPressed)),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: SingleChildScrollView(
              padding: const EdgeInsetsDirectional.all(ThemeDimensions.margin),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // ── Title + subtitle ──
                  AppText(
                    context.tr('authCreateAccountTitle'),
                    baseFontSize: 28,
                    breakpoint: bp,
                    textAlign: TextAlign.center,
                    style: context.textTheme.headlineMedium!.copyWith(
                      color: s.textPrimary,
                    ),
                  ),
                  const SizedBox(height: ThemeDimensions.spaceSm),
                  AppText(
                    context.tr('authSignUpSubtitle'),
                    baseFontSize: 14,
                    breakpoint: bp,
                    textAlign: TextAlign.center,
                    style: context.textTheme.bodyMedium!.copyWith(
                      color: s.textSecondary,
                    ),
                  ),
                  const SizedBox(height: ThemeDimensions.spaceLg),

                  // ── Full name ──
                  TextFormField(
                    controller: _nameController,
                    textInputAction: TextInputAction.next,
                    textCapitalization: TextCapitalization.words,
                    autofillHints: const [AutofillHints.name],
                    decoration: InputDecoration(
                      labelText: context.tr('authFullName'),
                      hintText: context.tr('authFullNameHint'),
                      prefixIcon: const Icon(Icons.person_outline),
                    ),
                  ),
                  const SizedBox(height: ThemeDimensions.spaceMd),

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
                    textInputAction: TextInputAction.next,
                    autofillHints: const [AutofillHints.newPassword],
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
                  const SizedBox(height: ThemeDimensions.space12),

                  // ── Strength bar ──
                  ClipRRect(
                    borderRadius: ThemeDimensions.borderRadiusPill,
                    child: LinearProgressIndicator(
                      value: _score / 4,
                      minHeight: 6,
                      backgroundColor: s.level2,
                      color: strengthColor(),
                    ),
                  ),
                  const SizedBox(height: ThemeDimensions.spaceSm),
                  Wrap(
                    spacing: ThemeDimensions.spaceMd,
                    runSpacing: ThemeDimensions.spaceXs,
                    children: [
                      _Rule(
                        label: context.tr('authRuleLength'),
                        ok: _hasLength,
                        bp: bp,
                      ),
                      _Rule(
                        label: context.tr('authRuleUppercase'),
                        ok: _hasUpper,
                        bp: bp,
                      ),
                      _Rule(
                        label: context.tr('authRuleNumber'),
                        ok: _hasNumber,
                        bp: bp,
                      ),
                      _Rule(
                        label: context.tr('authRuleSymbol'),
                        ok: _hasSymbol,
                        bp: bp,
                      ),
                    ],
                  ),
                  const SizedBox(height: ThemeDimensions.spaceMd),

                  // ── Confirm password ──
                  TextFormField(
                    controller: _confirmController,
                    obscureText: _obscureConfirm,
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration(
                      labelText: context.tr('authConfirmPassword'),
                      prefixIcon: const Icon(Icons.lock_reset_outlined),
                      suffixIcon: IconButton(
                        tooltip: _obscureConfirm
                            ? context.tr('authShowPassword')
                            : context.tr('authHidePassword'),
                        onPressed: () =>
                            setState(() => _obscureConfirm = !_obscureConfirm),
                        icon: Icon(
                          _obscureConfirm
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: ThemeDimensions.spaceSm),

                  // ── Terms ──
                  InkWell(
                    onTap: () => setState(() => _acceptTerms = !_acceptTerms),
                    borderRadius: ThemeDimensions.borderRadiusMedium,
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(
                        minHeight: ThemeDimensions.touchTarget,
                      ),
                      child: Row(
                        children: [
                          Checkbox(
                            value: _acceptTerms,
                            onChanged: (v) =>
                                setState(() => _acceptTerms = v ?? false),
                          ),
                          Expanded(
                            child: AppText(
                              context.tr('authAcceptTerms'),
                              baseFontSize: 13,
                              breakpoint: bp,
                              style: context.textTheme.bodySmall!.copyWith(
                                color: s.textSecondary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: ThemeDimensions.spaceMd),

                  // ── Sign up button ──
                  ElevatedButton(
                    onPressed: (widget.isLoading || !_acceptTerms)
                        ? null
                        : () => widget.onSignUpPressed?.call(
                            _nameController.text.trim(),
                            _emailController.text.trim(),
                            _passwordController.text,
                          ),
                    child: widget.isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Text(context.tr('authSignUp')),
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

                  // ── Login link ──
                  Wrap(
                    alignment: WrapAlignment.center,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      AppText(
                        context.tr('authHaveAccount'),
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
                        onPressed: widget.onLoginPressed,
                        child: AppText(
                          context.tr('authSignInLink'),
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

class _Rule extends StatelessWidget {
  const _Rule({required this.label, required this.ok, required this.bp});

  final String label;
  final bool ok;
  final AppBreakpoint bp;

  @override
  Widget build(BuildContext context) {
    final color = ok
        ? context.statusColors.success
        : context.surfaceColors.textMuted;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          ok ? Icons.check_circle : Icons.radio_button_unchecked,
          size: 16,
          color: color,
        ),
        const SizedBox(width: ThemeDimensions.spaceXs),
        AppText(
          label,
          baseFontSize: 12,
          breakpoint: bp,
          style: context.textTheme.bodySmall!.copyWith(color: color),
        ),
      ],
    );
  }
}
