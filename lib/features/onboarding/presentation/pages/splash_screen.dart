
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/routing/route_names.dart';
import '../../../../core/theme/theme_colors.dart';
import '../../../../core/theme/theme_dimensions.dart';
import '../../../../core/theme/theme_text_styles.dart';
import '../../../onboarding/presentation/cubit/onboarding_cubit.dart';
import '../../../onboarding/presentation/cubit/onboarding_state.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  static const Duration _minimumSplashDuration =
      Duration(seconds: 2);

  bool _navigated = false;
  bool _minimumDurationElapsed = false;

  OnboardingCubitState? _latestState;
  Timer? _splashTimer;

  @override
  void initState() {
    super.initState();

    _splashTimer = Timer(_minimumSplashDuration, () {
      if (!mounted) return;

      _minimumDurationElapsed = true;
      _tryNavigate();
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      final cubit = context.read<OnboardingCubit>();
      _latestState = cubit.state;

      // Start checking only if the app has not started the check yet.
      if (_latestState!.status == OnboardingStatus.initial) {
        cubit.checkOnboardingStatus();
      }

      _tryNavigate();
    });
  }

  void _handleState(OnboardingCubitState state) {
    _latestState = state;
    _tryNavigate();
  }

  void _tryNavigate() {
    if (!mounted ||
        _navigated ||
        !_minimumDurationElapsed ||
        _latestState == null) {
      return;
    }

    switch (_latestState!.status) {
      case OnboardingStatus.notCompleted:
        _navigateTo(RouteNames.onboarding);
        return;

      case OnboardingStatus.completed:
        _navigateTo(RouteNames.authentication);
        return;

      case OnboardingStatus.initial:
      case OnboardingStatus.loading:
      case OnboardingStatus.error:
        return;
    }
  }

  void _navigateTo(String routeName) {
    if (!mounted || _navigated) return;

    _navigated = true;

    Navigator.of(context).pushReplacementNamed(routeName);
  }

  @override
  void dispose() {
    _splashTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<OnboardingCubit, OnboardingCubitState>(
      listener: (context, state) => _handleState(state),
      child: BlocBuilder<OnboardingCubit, OnboardingCubitState>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: ThemeColors.darkCanvas,
            body: SafeArea(
              child: Center(
                child: state.status == OnboardingStatus.error
                    ? _ErrorView(
                        message:
                            state.errorMessage ?? context.tr('error'),
                        onRetry: () {
                          context
                              .read<OnboardingCubit>()
                              .checkOnboardingStatus();
                        },
                      )
                    : const _SplashView(),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _SplashView extends StatefulWidget {
  const _SplashView();

  @override
  State<_SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<_SplashView>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _scale;
  late final Animation<double> _fade;

  @override
  void initState() {
    super.initState();

    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _scale = Tween<double>(
      begin: 0.80,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _ctrl,
        curve: Curves.elasticOut,
      ),
    );

    _fade = CurvedAnimation(
      parent: _ctrl,
      curve: Curves.easeIn,
    );

    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context);

    return FadeTransition(
      opacity: _fade,
      child: ScaleTransition(
        scale: _scale,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
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
                boxShadow: ThemeDimensions.shadowDarkTier2,
              ),
              child: const Center(
                child: Icon(
                  Icons.biotech,
                  color: Colors.white,
                  size: 40,
                ),
              ),
            ),
            const SizedBox(height: ThemeDimensions.spaceMd),
            Text(
              'NutriVision',
              style: ThemeTextStyles.headlineLargeMobile.copyWith(
                color: ThemeColors.darkTextPrimary,
                fontFamily:
                    ThemeTextStyles.headingFamilyFor(locale),
              ),
            ),
            const SizedBox(height: ThemeDimensions.spaceXs),
            Text(
              context.tr('clinicalIntelligence'),
              style: ThemeTextStyles.bodyMedium.copyWith(
                color: ThemeColors.darkTextMuted,
                fontFamily: ThemeTextStyles.fontFamilyFor(locale),
              ),
            ),
            const SizedBox(height: ThemeDimensions.space40),
            const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(
                  ThemeColors.primary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({
    required this.message,
    required this.onRetry,
  });

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(ThemeDimensions.spaceLg),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.error_outline,
            size: 48,
            color: ThemeColors.criticalDark,
          ),
          const SizedBox(height: ThemeDimensions.spaceMd),
          Text(
            message,
            textAlign: TextAlign.center,
            style: ThemeTextStyles.bodyMedium.copyWith(
              color: ThemeColors.darkTextSecondary,
            ),
          ),
          const SizedBox(height: ThemeDimensions.spaceLg),
          ElevatedButton.icon(
            onPressed: () {
              context
                  .read<OnboardingCubit>()
                  .checkOnboardingStatus();
            },
            icon: const Icon(Icons.refresh),
            label: Text(context.tr('retry')),
          ),
        ],
      ),
    );
  }
}
