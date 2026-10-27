import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nutri_vision/core/extensions/context_extensions.dart';
import 'package:nutri_vision/core/routing/route_names.dart';
import 'package:nutri_vision/core/theme/theme_dimensions.dart';
import 'package:nutri_vision/core/theme/theme_extensions.dart';
import '../cubit/onboarding_cubit.dart';
import '../cubit/onboarding_state.dart';
import '../widgets/onboarding_card_shell.dart';
import '../widgets/onboarding_footer.dart';
import '../widgets/onboarding_header.dart';
import '../widgets/onboarding_slide.dart';
import '../widgets/onboarding_slide_data.dart';
import '../widgets/onboarding_toolbar.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key, this.slides = kOnboardingSlides});

  final List<OnboardingSlideData> slides;

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage>
    with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  late final AnimationController _pulseCtrl;
  late final Animation<double> _pulse;

  @override
  void initState() {
    super.initState();
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);
    _pulse = Tween<double>(
      begin: 0.35,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _pageController.dispose();
    _pulseCtrl.dispose();
    super.dispose();
  }

  void _onNext() {
    if (_currentPage < widget.slides.length - 1) {
      _goToStep(_currentPage + 1);
    } else {
      _complete();
    }
  }

  void _onBack() {
    if (_currentPage > 0) {
      _goToStep(_currentPage - 1);
    }
  }

  void _goToStep(int index) {
    if (index >= 0 && index < widget.slides.length && index != _currentPage) {
      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  void _onSkip() => _complete();

  Future<void> _complete() async {
    await context.read<OnboardingCubit>().complete();
  }

  void _handleState(BuildContext context, OnboardingCubitState state) {
    if (state.status == OnboardingStatus.completed) {
      Navigator.of(
        context,
      ).pushNamedAndRemoveUntil(RouteNames.authentication, (_) => false);
    } else if (state.status == OnboardingStatus.error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(state.errorMessage ?? context.tr('error')),
          backgroundColor: Theme.of(context).colorScheme.error,
          behavior: SnackBarBehavior.floating,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final surfaces = context.surfaceColors;
    final isDark = context.isDarkMode;

    return BlocListener<OnboardingCubit, OnboardingCubitState>(
      listener: _handleState,
      child: Scaffold(
        backgroundColor: surfaces.canvas,
        body: SafeArea(
          child: Column(
            children: [
              OnboardingHeader(isDark: isDark),

              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 1100),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: ThemeDimensions.marginMobile,
                          vertical: ThemeDimensions.spaceSm,
                        ),
                        child: Column(
                          children: [
                            OnboardingToolbar(
                              currentPage: _currentPage,
                              totalPages: widget.slides.length,
                              pulse: _pulse,
                              onStepTap: _goToStep,
                              onSkip: _onSkip,
                              isDark: isDark,
                            ),

                            const SizedBox(height: ThemeDimensions.spaceMd),

                            OnboardingCardShell(
                              isDark: isDark,
                              child: SizedBox(
                                height: 780,
                                child: PageView.builder(
                                  controller: _pageController,
                                  itemCount: widget.slides.length,
                                  onPageChanged: (index) {
                                    setState(() => _currentPage = index);
                                  },
                                  itemBuilder: (context, index) {
                                    return OnboardingSlide(
                                      data: widget.slides[index],
                                      slideIndex: index,
                                      totalSlides: widget.slides.length,
                                      onNext: _onNext,
                                      onBack: _onBack,
                                      onJumpToHabits: () => _goToStep(2),
                                    );
                                  },
                                ),
                              ),
                            ),

                            const SizedBox(height: ThemeDimensions.spaceLg),

                            OnboardingFooter(
                              currentPage: _currentPage,
                              totalPages: widget.slides.length,
                              onDotTap: _goToStep,
                              isDark: isDark,
                            ),

                            const SizedBox(height: ThemeDimensions.spaceLg),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
