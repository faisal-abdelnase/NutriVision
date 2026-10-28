import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nutri_vision/core/localization/app_localizations.dart';
import 'package:nutri_vision/core/localization/locale_cubit.dart';
import 'package:nutri_vision/core/localization/localization_config.dart';
import 'package:nutri_vision/core/routing/route_names.dart';
import 'package:nutri_vision/core/theme/app_theme.dart';
import 'package:nutri_vision/core/theme/theme_cubit.dart';
import 'package:nutri_vision/features/nutrition_profile/domain/entities/nutrition_profile.dart';
import 'package:nutri_vision/features/nutrition_profile/domain/repositories/nutrition_profile_repository.dart';
import 'package:nutri_vision/features/nutrition_profile/domain/usecases/create_nutrition_profile.dart';
import 'package:nutri_vision/features/nutrition_profile/domain/usecases/get_nutrition_profile.dart';
import 'package:nutri_vision/features/nutrition_profile/domain/usecases/update_dietary_preferences.dart';
import 'package:nutri_vision/features/nutrition_profile/domain/usecases/update_nutrition_goals.dart';
import 'package:nutri_vision/features/nutrition_profile/domain/usecases/update_nutrition_profile.dart';
import 'package:nutri_vision/features/nutrition_profile/presentation/cubit/nutrition_profile_cubit.dart';
import 'package:nutri_vision/features/nutrition_profile/presentation/pages/info_completion_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FakeNutritionProfileRepository implements NutritionProfileRepository {
  NutritionProfile? profile;

  @override
  Future<NutritionProfile> createNutritionProfile({
    required NutritionProfile profile,
  }) async {
    this.profile = profile;
    return profile;
  }

  @override
  Future<NutritionProfile?> getNutritionProfile({
    required String userId,
  }) async {
    return profile;
  }

  @override
  Future<NutritionProfile> updateDietaryPreferences({
    required String userId,
    required List<String> dietaryPreferences,
    required List<String> allergies,
  }) async {
    return profile!;
  }

  @override
  Future<NutritionProfile> updateNutritionGoals({
    required String userId,
    required double dailyCalorieTarget,
    required double proteinTargetGrams,
    required double carbohydrateTargetGrams,
    required double fatTargetGrams,
  }) async {
    return profile!;
  }

  @override
  Future<NutritionProfile> updateNutritionProfile({
    required NutritionProfile profile,
  }) async {
    this.profile = profile;
    return profile;
  }
}

Widget createTestApp({
  required SharedPreferences preferences,
  required NutritionProfileCubit cubit,
  int initialStep = 0,
}) {
  return MultiBlocProvider(
    providers: [
      BlocProvider<ThemeCubit>(create: (_) => ThemeCubit(preferences)),
      BlocProvider<LocaleCubit>(create: (_) => LocaleCubit(preferences)),
      BlocProvider<NutritionProfileCubit>.value(value: cubit),
    ],
    child: MaterialApp(
      locale: LocalizationConfig.english,
      supportedLocales: LocalizationConfig.supportedLocales,
      localizationsDelegates: LocalizationConfig.delegates,
      theme: AppTheme.light(LocalizationConfig.english),
      routes: {
        RouteNames.home: (_) => const Scaffold(body: Text('Home Dashboard')),
        RouteNames.onboarding: (_) => const Scaffold(body: Text('Onboarding')),
      },
      home: InfoCompletionPage(initialStep: initialStep),
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
    });
  });

  group('InfoCompletionPage Widget Tests', () {
    late FakeNutritionProfileRepository fakeRepo;
    late NutritionProfileCubit cubit;
    late SharedPreferences preferences;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      preferences = await SharedPreferences.getInstance();
      fakeRepo = FakeNutritionProfileRepository();
      cubit = NutritionProfileCubit(
        getNutritionProfile: GetNutritionProfile(fakeRepo),
        createNutritionProfile: CreateNutritionProfile(fakeRepo),
        updateNutritionProfile: UpdateNutritionProfile(fakeRepo),
        updateNutritionGoals: UpdateNutritionGoals(fakeRepo),
        updateDietaryPreferences: UpdateDietaryPreferences(fakeRepo),
      );
    });

    testWidgets('Step 1: renders physical baseline calibration and profiler', (
      tester,
    ) async {
      await tester.binding.setSurfaceSize(const Size(1280, 900));

      await tester.pumpWidget(
        createTestApp(preferences: preferences, cubit: cubit, initialStep: 0),
      );
      await tester.pumpAndSettle();

      // Verify Header & Profiler
      expect(find.text('Physical Baseline Calibration'), findsOneWidget);
      expect(find.text('NUTRIVISION METABOLIC PROFILER'), findsOneWidget);
      expect(find.text('Tell us about your physical baseline'), findsOneWidget);
      expect(find.text('Estimated BMR'), findsOneWidget);
      expect(find.text('Estimated TDEE'), findsOneWidget);

      // Verify Continue Button
      expect(find.text('Continue to Dietary Goals'), findsOneWidget);
    });

    testWidgets('Step 2: renders what is your goal and allows goal selection', (
      tester,
    ) async {
      await tester.binding.setSurfaceSize(const Size(1280, 900));

      await tester.pumpWidget(
        createTestApp(preferences: preferences, cubit: cubit, initialStep: 1),
      );
      await tester.pumpAndSettle();

      // Verify Screen 2 content
      expect(find.text("What's your goal?"), findsOneWidget);
      expect(find.text('Lose Weight'), findsOneWidget);
      expect(find.text('Maintain Weight'), findsOneWidget);
      expect(find.text('Gain Muscle'), findsOneWidget);
      expect(find.text('Eat Healthier'), findsOneWidget);

      // Tap on Gain Muscle
      await tester.tap(find.text('Gain Muscle'));
      await tester.pumpAndSettle();

      expect(find.text('Gain Muscle Mode'), findsOneWidget);
      expect(find.text('Continue to Preferences'), findsOneWidget);
    });

    testWidgets(
      'Step 3: renders preferences, safeguards, allergens, and completion',
      (tester) async {
        await tester.binding.setSurfaceSize(const Size(1280, 900));

        await tester.pumpWidget(
          createTestApp(preferences: preferences, cubit: cubit, initialStep: 2),
        );
        await tester.pumpAndSettle();

        // Verify Screen 3 content
        expect(
          find.text('Customize your nutrition rules & safeguards'),
          findsOneWidget,
        );
        expect(find.text('Section A: Core Dietary Regimen'), findsOneWidget);
        expect(
          find.text('Section B: Medical Allergens & Celiac Flags'),
          findsOneWidget,
        );
        expect(
          find.text('Section C: Food Dislikes & Sensory Avoidance'),
          findsOneWidget,
        );
        expect(find.text('LIVE AI SAFETY TELEMETRY'), findsOneWidget);

        // Tap Complete Setup
        final completeButton = find
            .text('Complete Setup & Launch Dashboard')
            .first;
        await tester.ensureVisible(completeButton);
        await tester.tap(completeButton);
        await tester.pumpAndSettle();

        // Verifies it navigated to Home Dashboard
        expect(find.text('Home Dashboard'), findsOneWidget);
      },
    );
  });
}
