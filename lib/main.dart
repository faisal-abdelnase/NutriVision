import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_ce_flutter/adapters.dart';
import 'package:nutri_vision/firebase_options.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app.dart';
import 'core/constants/api_constants.dart';
import 'core/di/ai_coach_injection.dart';
import 'core/di/dashboard_injection.dart';
import 'core/di/meal_analysis_injection.dart';
import 'core/di/meal_tracking_injection.dart';
import 'core/di/nutrition_profile_injection.dart';
import 'core/di/onboarding_injection.dart';
import 'core/di/profile_injection.dart';
import 'core/di/progress_di.dart';
import 'core/di/recipes_di.dart';
import 'core/logging/ai_coach_diagnostics.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);

if (kIsWeb) {
  if (kDebugMode) {
    await FirebaseAppCheck.instance.activate(
      providerWeb: WebDebugProvider(),
    );

    

    AiCoachDiagnostics.info(
      'App Check activated using Web Debug Provider.',
    );
  } else {
    const siteKey = String.fromEnvironment(
      'FIREBASE_APP_CHECK_RECAPTCHA_SITE_KEY',
    );

    if (siteKey.isEmpty) {
      throw StateError(
        'Missing FIREBASE_APP_CHECK_RECAPTCHA_SITE_KEY.',
      );
    }

    await FirebaseAppCheck.instance.activate(
      providerWeb: ReCaptchaV3Provider(siteKey),
    );
  }
} else {
  await FirebaseAppCheck.instance.activate(
    providerAndroid: kDebugMode
        ? AndroidDebugProvider()
        : AndroidPlayIntegrityProvider(),
    providerApple: kDebugMode
        ? AppleDebugProvider()
        : AppleDeviceCheckProvider(),
  );
}

  await Hive.initFlutter();

  await Hive.openBox('ai_coach_messages');
  await Hive.openBox('ai_coach_conversations');
  await Hive.openBox('ai_coach_advice');

  final serviceLocator = GetIt.instance;
  await registerOnboardingDependencies();
  serviceLocator.registerLazySingleton<Dio>(
    () => Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: ApiConstants.connectTimeout,
        receiveTimeout: ApiConstants.receiveTimeout,
      ),
    ),
  );

  registerDashboardDependencies();
  registerProfileDependencies();
  registerProgressDependencies();
  await registerRecipesDependencies();
  await initMealTrackingDependencies();
  await initMealAnalysisInjection();
  await registerAiCoachDependencies();
  await setupServiceLocator();
  final preferences = serviceLocator<SharedPreferences>();

  runApp(NutriVision(preferences: preferences));
}
