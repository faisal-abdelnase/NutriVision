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

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // Firebase App Check must be activated before Firebase requests.

  //90FCC593-50ED-48D8-ACB5-F6F3D4BCB7F6
  //fcffd63d-56b7-491b-9b59-35aaa4f6f4ed
  if (kIsWeb) {
    if (kDebugMode) {
      await FirebaseAppCheck.instance.activate(
        providerWeb: WebDebugProvider(),
      );
    } else {
      const siteKey = String.fromEnvironment(
        '6Le-2PstAAAAAFyKTvNr-kwSUKJ-lbeO6gCl1I4P',
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
      androidProvider: kDebugMode
          ? AndroidProvider.debug
          : AndroidProvider.playIntegrity,
      appleProvider: kDebugMode
          ? AppleProvider.debug
          : AppleProvider.deviceCheck,
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
