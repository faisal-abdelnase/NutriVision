import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:nutri_vision/firebase_options.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app.dart';
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
  registerDashboardDependencies();
  registerProfileDependencies();
  registerProgressDependencies();
  registerRecipesDependencies();
  initMealTrackingDependencies();
  initMealAnalysisInjection();
  await setupServiceLocator();
  await registerOnboardingDependencies();
  final preferences = await SharedPreferences.getInstance();
  runApp(NutriVision(preferences: preferences));
}
