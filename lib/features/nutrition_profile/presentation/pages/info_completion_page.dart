import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/routing/route_names.dart';
import '../../../../core/theme/theme_colors.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../domain/entities/nutrition_profile.dart';
import '../cubit/nutrition_profile_cubit.dart';
import '../models/info_completion_state.dart';
import '../widgets/info_stepper_header.dart';
import '../widgets/info_top_app_bar.dart';
import '../widgets/info_validation_alert_banner.dart';
import '../widgets/step1_biometrics_calibration.dart';
import '../widgets/step2_dietary_goals.dart';
import '../widgets/step3_preferences_safeguards.dart';

class InfoCompletionPage extends StatefulWidget {
  const InfoCompletionPage({super.key, this.initialStep = 0});

  final int initialStep;

  @override
  State<InfoCompletionPage> createState() => _InfoCompletionPageState();
}

class _InfoCompletionPageState extends State<InfoCompletionPage> {
  late final PageController _pageController;
  late int _currentStep;
  InfoCompletionData _data = const InfoCompletionData();
  bool _showValidationAlert = false;

  @override
  void initState() {
    super.initState();
    _currentStep = widget.initialStep;
    _pageController = PageController(initialPage: _currentStep);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      try {
        final existing = context.read<NutritionProfileCubit>().currentProfile;
        if (existing != null && existing.isCalibrated) {
          setState(() {
            _data = InfoCompletionData.fromNutritionProfile(existing);
          });
        }
      } catch (_) {}
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goToStep(int step) {
    if (step >= 0 && step <= 2 && step != _currentStep) {
      setState(() => _currentStep = step);
      _pageController.animateToPage(
        step,
        duration: const Duration(milliseconds: 380),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  void _onDataChanged(InfoCompletionData updated) {
    setState(() => _data = updated);
  }

  void _handleBack() {
    if (_currentStep > 0) {
      _goToStep(_currentStep - 1);
    } else {
      if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      } else {
        Navigator.of(context).pushReplacementNamed(RouteNames.onboarding);
      }
    }
  }

  Future<void> _handleComplete() async {
    String uid = 'guest_user';
    try {
      uid = FirebaseAuth.instance.currentUser?.uid ?? 'guest_user';
    } catch (_) {
      uid = 'guest_user';
    }

    final profile = NutritionProfile(
      userId: uid,
      age: _data.age,
      heightCm: _data.heightCm,
      weightKg: _data.weightKg,
      goal: _data.goal.name,
      dailyCalorieTarget: _data.targetCalories.toDouble(),
      proteinTargetGrams: _data.proteinGrams.toDouble(),
      carbohydrateTargetGrams: _data.carbGrams.toDouble(),
      fatTargetGrams: _data.fatGrams.toDouble(),
      dietaryPreferences: [_data.regimen.name, ..._data.selectedDislikes],
      allergies: [..._data.selectedAllergens, ..._data.customAllergens],
      updatedAt: DateTime.now(),
    );

    try {
      await context.read<NutritionProfileCubit>().createProfile(
        profile: profile,
      );
    } catch (_) {}

    if (!mounted) return;

    final locale = Localizations.localeOf(context);
    final isRtl =
        Directionality.of(context) == TextDirection.rtl ||
        locale.languageCode == 'ar';

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(
              Icons.check_circle_rounded,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                isRtl
                    ? 'تمت المعايرة بنجاح! تم تثبيت ملفك الغذائي المخصص.'
                    : 'Calibration Complete! Baseline profile established.',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        backgroundColor: ThemeColors.stitchPrimary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );

    Navigator.of(
      context,
    ).pushNamedAndRemoveUntil(RouteNames.home, (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    final surfaces = context.surfaceColors;

    return Scaffold(
      backgroundColor: surfaces.canvas,
      body: SafeArea(
        child: Column(
          children: [
            InfoTopAppBar(
              showSimulatorDeck: false,
              onMetricSelected: () {
                _onDataChanged(
                  _data.copyWith(system: MeasurementSystem.metric),
                );
              },
              onImperialSelected: () {
                _onDataChanged(
                  _data.copyWith(system: MeasurementSystem.imperial),
                );
              },
              onToggleAlert: () {
                setState(() => _showValidationAlert = !_showValidationAlert);
              },
            ),

            InfoStepperHeader(
              currentStep: _currentStep,
              onStepTapped: _goToStep,
            ),

            if (_showValidationAlert)
              InfoValidationAlertBanner(
                onClose: () => setState(() => _showValidationAlert = false),
              ),

            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (idx) {
                  setState(() => _currentStep = idx);
                },
                children: [
                  Step1BiometricsCalibration(
                    data: _data,
                    onDataChanged: _onDataChanged,
                    onNext: () => _goToStep(1),
                    onBack: _handleBack,
                  ),
                  Step2DietaryGoals(
                    data: _data,
                    onDataChanged: _onDataChanged,
                    onNext: () => _goToStep(2),
                    onBack: () => _goToStep(0),
                  ),
                  Step3PreferencesSafeguards(
                    data: _data,
                    onDataChanged: _onDataChanged,
                    onComplete: _handleComplete,
                    onBack: () => _goToStep(1),
                    onSkip: _handleComplete,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
