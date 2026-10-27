import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nutri_vision/core/localization/app_localizations.dart';
import 'package:nutri_vision/core/localization/localization_config.dart';
import 'package:nutri_vision/core/routing/route_names.dart';
import 'package:nutri_vision/core/theme/app_theme.dart';
import 'package:nutri_vision/features/onboarding/domain/entities/onboarding_state.dart';
import 'package:nutri_vision/features/onboarding/domain/repositories/onboarding_repository.dart';
import 'package:nutri_vision/features/onboarding/domain/usecases/complete_onboarding.dart';
import 'package:nutri_vision/features/onboarding/domain/usecases/has_completed_onboarding.dart';
import 'package:nutri_vision/features/onboarding/presentation/cubit/onboarding_cubit.dart';
import 'package:nutri_vision/features/onboarding/presentation/pages/onboarding_page.dart';
import 'package:nutri_vision/features/onboarding/presentation/widgets/onboarding_page_indicator.dart';

class FakeOnboardingRepository implements OnboardingRepository {
  bool isCompleted = false;

  @override
  Future<OnboardingState> getOnboardingState() async {
    return OnboardingState(isCompleted: isCompleted);
  }

  @override
  Future<void> completeOnboarding() async {
    isCompleted = true;
  }
}

Widget createTestWidget({
  required OnboardingCubit cubit,
  Locale locale = LocalizationConfig.english,
}) {
  return BlocProvider<OnboardingCubit>.value(
    value: cubit,
    child: MaterialApp(
      locale: locale,
      supportedLocales: LocalizationConfig.supportedLocales,
      localizationsDelegates: LocalizationConfig.delegates,
      theme: AppTheme.light(locale),
      routes: {
        RouteNames.authentication: (_) => const Scaffold(body: Text('Auth')),
      },
      home: const OnboardingPage(),
    ),
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    AppLocalizations.setMockStrings('en', {
      'appName': 'NutriVision',
      'clinicalIntelligence': 'Clinical Intelligence',
      'skip': 'Skip',
      'next': 'Next',
      'back': 'Back',
      'getStarted': 'Get Started Now',
      'badgeClinical': 'Clinical Telemetry v2.4',
      'onboardingFlow': 'Onboarding Sequence',
      'step1Tag': 'STEP 1 OF 3 • BIO-TELEMETRY',
      'step1Sub': '4K Food Sensor AI',
      'btnContinueStep1': 'Continue to AI Insights',
      'btnJumpHabits': 'Jump to Habits',
      'caloricEst': 'Est. Caloric Load',
      'glycemicImpact': 'Glycemic Impact',
      'lowGI': 'Low GI • 28',
      'protein': 'Protein',
      'complexCarbs': 'Complex Carbs',
      'healthyFats': 'Healthy Fats',
      'fiber': '8.4g Fiber',
      'omega3': '1.2g Omega-3',
      'zincFe': 'Zinc & Fe+',
      'step2Tag': 'STEP 2 OF 3 • CLINICAL INTELLIGENCE',
      'step2Sub': 'Neural Engine L-9',
      'btnContinueStep2': 'Continue to Habit Builder',
      'bioScanActive': 'BIO_SCAN_ACTIVE',
      'matchPct': '98.4% Match',
      'swapAdviceTitle': 'NutriVision Swap Advice',
      'swapScore': '-38% Glycemic Index',
      'swapFrom': 'Refined White Bread',
      'swapTo': 'Sprouted Sourdough',
      'swapReasoning': 'Fermentation degrades phytates.',
      'identifiedFood': 'Identified: Whole Wheat Bagel + Cream',
      'glycemicWarning': 'Elevated glycemic surge detected',
      'step3Tag': 'STEP 3 OF 3 • METABOLIC MASTERY',
      'step3Sub': 'Longitudinal Cohort',
      'streakBadge': 'Consistency Mastery',
      'streakDays': '14 Days Perfect',
      'goalNutrition': 'Nutrient Target',
      'statusOptimal': 'Optimal Range',
      'goalHydration': 'Hydration',
      'weekOverview': 'Weekly Metabolic Cadence',
      'navOverview': 'Overview',
      'navDietaryPlan': 'Dietary Plan',
      'navTelemetryGoals': 'Telemetry Goals',
      'navPreferences': 'Preferences',
      'onboardingTitle1': 'Understand What You Eat',
      'onboardingBody1':
          'Track your meals and understand their nutritional value.',
      'onboardingTitle2': 'AI-Powered Insights',
      'onboardingBody2': 'Get personalized nutritional insights.',
      'onboardingTitle3': 'Build Healthier Habits',
      'onboardingBody3': 'Track your progress and make better decisions.',
      'onboardingBullet1aTitle': 'Multi-Layer Volumetric Sizing',
      'onboardingBullet1aSubtitle':
          'Computes portion mass directly from photographic depth maps.',
      'onboardingBullet1bTitle': 'Micro & Macro Breakdown',
      'onboardingBullet1bSubtitle':
          'Instant visualization of protein, slow carbs, healthy fats.',
      'onboardingBullet2aTitle': 'Metabolic Inflammation Shield',
      'onboardingBullet2aSubtitle': 'Identifies refined sugars and seed oils.',
      'onboardingBullet2bTitle': 'Automated Healthy Swaps',
      'onboardingBullet2bSubtitle': 'Recommends nutrient-dense alternatives.',
      'onboardingBullet3aTitle': '14-Day Metabolic Consistency Streak',
      'onboardingBullet3aSubtitle': 'Positive neurological anchoring.',
      'onboardingBullet3bTitle': 'Integrative Clinical Reports',
      'onboardingBullet3bSubtitle': 'Exportable PDF logs.',
      'onboardingDisclaimer':
          'NutriVision provides estimated dietary insights. Not intended for clinical or medical diagnosis.',
      'slide1FoodTitle': 'Wild Salmon & Quinoa Bowl',
      'slide1Accuracy': '99.2% Acc.',
      'slide1CaloricLoad': '542',
      'slide1CaloricUnit': 'kcal',
      'slide1ProteinVal': '38g',
      'slide1ProteinTarget': '78% target',
      'slide1CarbsVal': '44g',
      'slide1CarbsTarget': '52% target',
      'slide1FatsVal': '19g',
      'slide1FatsTarget': '40% target',
      'slide1Fiber': '8.4g Fiber',
      'slide1Omega3': '1.2g Omega-3',
      'slide1Zinc': 'Zinc & Fe+',
      'slide2SwapFromStats': 'GI: 75 • Fiber: 1.1g',
      'slide2SwapToStats': 'GI: 47 • Fiber: 5.6g',
      'slide3Points': '+180 Pts',
      'slide3HydrationVal': '2.4 / 2.8',
      'slide3HydrationUnit': 'L',
      'slide3HydrationProgress': '85% completed',
      'slide3HydrationRemaining': '400ml left',
      'slide3CadenceDays': '7/7 Days',
      'dayMon': 'M',
      'dayTue': 'T',
      'dayWed': 'W',
      'dayThu': 'T',
      'dayFri': 'F',
      'daySat': 'S',
      'daySun': 'S',
    });
  });

  late FakeOnboardingRepository repo;
  late OnboardingCubit cubit;

  setUp(() {
    repo = FakeOnboardingRepository();
    cubit = OnboardingCubit(
      hasCompletedOnboarding: HasCompletedOnboarding(repo),
      completeOnboarding: CompleteOnboarding(repo),
    );
  });

  tearDown(() {
    cubit.close();
  });

  testWidgets('renders top bar, indicators, and first slide content', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    await tester.pumpWidget(createTestWidget(cubit: cubit));
    await tester.pump(const Duration(milliseconds: 600));

    // Verify NutriVision title exists
    expect(find.text('NutriVision'), findsWidgets);

    // Verify Page indicator exists
    expect(find.byType(OnboardingPageIndicator), findsOneWidget);

    // Verify First slide step badge
    expect(find.textContaining('STEP 1 OF 3'), findsOneWidget);
  });

  testWidgets('tapping Skip calls complete on cubit', (tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    await tester.pumpWidget(createTestWidget(cubit: cubit));
    await tester.pump(const Duration(milliseconds: 600));

    final skipButton = find.widgetWithText(TextButton, 'Skip');
    expect(skipButton, findsOneWidget);

    await tester.tap(skipButton);
    await tester.pump(const Duration(milliseconds: 400));

    expect(repo.isCompleted, isTrue);
  });

  testWidgets('tapping Next advances to next slide', (tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    await tester.pumpWidget(createTestWidget(cubit: cubit));
    await tester.pump(const Duration(milliseconds: 600));

    expect(find.textContaining('STEP 1 OF 3'), findsOneWidget);

    // Tap CTA ElevatedButton (Continue to AI Insights)
    final nextButton = find.byType(ElevatedButton).first;
    expect(nextButton, findsOneWidget);

    await tester.ensureVisible(nextButton);
    await tester.tap(nextButton);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 250));
    await tester.pump(const Duration(milliseconds: 250));

    expect(find.textContaining('STEP 2 OF 3'), findsOneWidget);
  });
}
