import 'package:flutter/material.dart';
import 'package:nutri_vision/core/extensions/context_extensions.dart';
import 'package:nutri_vision/core/theme/theme_dimensions.dart';
import 'package:nutri_vision/core/theme/theme_extensions.dart';
import 'package:nutri_vision/core/theme/theme_text_styles.dart';
import 'components/onboarding_action_buttons.dart';
import 'components/onboarding_feature_bullet.dart';
import 'components/onboarding_illustration.dart';
import 'components/onboarding_step_badge.dart';
import 'onboarding_slide_data.dart';

class OnboardingSlide extends StatefulWidget {
  const OnboardingSlide({
    super.key,
    required this.data,
    required this.slideIndex,
    required this.totalSlides,
    required this.onNext,
    this.onBack,
    this.onJumpToHabits,
  });

  final OnboardingSlideData data;
  final int slideIndex;
  final int totalSlides;
  final VoidCallback onNext;
  final VoidCallback? onBack;
  final VoidCallback? onJumpToHabits;

  @override
  State<OnboardingSlide> createState() => _OnboardingSlideState();
}

class _OnboardingSlideState extends State<OnboardingSlide>
    with TickerProviderStateMixin {
  late final AnimationController _entranceCtrl;
  late final Animation<double> _fade;
  late final Animation<Offset> _slideUp;

  late final AnimationController _pulseCtrl;
  late final Animation<double> _pulse;

  late final AnimationController _pingCtrl;
  late final Animation<double> _ping;

  late final AnimationController _spinCtrl;
  late final AnimationController _progressCtrl;
  late final Animation<double> _progressAnim;

  @override
  void initState() {
    super.initState();
    _entranceCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 550),
    );
    _fade = CurvedAnimation(parent: _entranceCtrl, curve: Curves.easeOut);
    _slideUp = Tween<Offset>(begin: const Offset(0, 0.05), end: Offset.zero)
        .animate(
          CurvedAnimation(parent: _entranceCtrl, curve: Curves.easeOutCubic),
        );

    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);
    _pulse = Tween<double>(
      begin: 0.35,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut));

    _pingCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
    _ping = Tween<double>(
      begin: 0.2,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _pingCtrl, curve: Curves.easeOut));

    _spinCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();

    _progressCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _progressAnim = CurvedAnimation(
      parent: _progressCtrl,
      curve: Curves.easeOutCubic,
    );

    _entranceCtrl.forward();
    _progressCtrl.forward();
  }

  @override
  void didUpdateWidget(covariant OnboardingSlide oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.slideIndex != widget.slideIndex) {
      _entranceCtrl.forward(from: 0);
      _progressCtrl.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _entranceCtrl.dispose();
    _pulseCtrl.dispose();
    _pingCtrl.dispose();
    _spinCtrl.dispose();
    _progressCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final surfaces = context.surfaceColors;
    final locale = Localizations.localeOf(context);
    final isDark = context.isDarkMode;

    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(
        position: _slideUp,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 580),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: ThemeDimensions.marginMobile,
                  vertical: ThemeDimensions.spaceSm,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    OnboardingIllustration(
                      slideIndex: widget.slideIndex,
                      pulse: _pulse,
                      ping: _ping,
                      spin: _spinCtrl,
                      progress: _progressAnim,
                      isDark: isDark,
                    ),

                    const SizedBox(height: ThemeDimensions.spaceLg),

                    OnboardingStepBadge(
                      slideIndex: widget.slideIndex,
                      totalSlides: widget.totalSlides,
                    ),

                    const SizedBox(height: ThemeDimensions.spaceSm + 4),

                    Text(
                      context.tr(widget.data.titleKey),
                      style:
                          (context.screenWidth < 600
                                  ? ThemeTextStyles.headlineLargeMobile
                                  : ThemeTextStyles.headlineLarge)
                              .copyWith(
                                color: surfaces.textPrimary,
                                fontFamily: ThemeTextStyles.headingFamilyFor(
                                  locale,
                                ),
                                fontWeight: FontWeight.w700,
                                letterSpacing: -0.3,
                              ),
                    ),

                    const SizedBox(height: ThemeDimensions.spaceSm),

                    Text(
                      context.tr(widget.data.bodyKey),
                      style: ThemeTextStyles.bodyLarge.copyWith(
                        color: surfaces.textSecondary,
                        fontFamily: ThemeTextStyles.fontFamilyFor(locale),
                        height: 1.55,
                      ),
                    ),

                    const SizedBox(height: ThemeDimensions.spaceLg),

                    ...widget.data.featureBullets.asMap().entries.map(
                      (entry) => OnboardingFeatureBullet(
                        bullet: entry.value,
                        slideIndex: widget.slideIndex,
                        bulletIndex: entry.key,
                      ),
                    ),

                    const SizedBox(height: ThemeDimensions.spaceLg),

                    OnboardingActionButtons(
                      slideIndex: widget.slideIndex,
                      onNext: widget.onNext,
                      onBack: widget.onBack,
                      onJumpToHabits: widget.onJumpToHabits,
                    ),

                    const SizedBox(height: ThemeDimensions.spaceMd),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
