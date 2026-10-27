import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
<<<<<<< HEAD
import '../../features/meal_analysis/domain/entities/analyzed_food_item.dart';
import '../../features/meal_analysis/domain/entities/meal_analysis_result.dart';
import '../../features/authentication/presentation/screens/login_screen.dart';
import '../../features/meal_analysis/presentation/pages/meal_analysis_page.dart';
=======
import '../../features/authentication/presentation/pages/auth_placeholder_page.dart';
import '../../features/onboarding/presentation/pages/onboarding_page.dart';
import '../../features/onboarding/presentation/pages/splash_screen.dart';
>>>>>>> 221dac99ad6eb8630614390a1cac750a9add04cb
import 'route_names.dart';

class AppRouter {
  AppRouter._();

  static Route<dynamic>? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      // case RouteNames.root:
      case RouteNames.splash:
        return MaterialPageRoute<void>(
          settings: settings,
<<<<<<< HEAD
          builder: (_) => LoginScreen(),
=======
          builder: (_) => const SplashScreen(),
>>>>>>> 221dac99ad6eb8630614390a1cac750a9add04cb
        );

      case RouteNames.onboarding:
<<<<<<< HEAD
      // return MaterialPageRoute<void>(
      //   settings: settings,
      //   builder: (_) => OnboardingPage(repository: onboardingRepository),
      // );
=======
        return PageRouteBuilder<void>(
          settings: settings,
          transitionDuration: const Duration(milliseconds: 500),
          reverseTransitionDuration: const Duration(milliseconds: 350),
          pageBuilder: (_, _, _) => const OnboardingPage(),
          transitionsBuilder: (_, animation, _, child) {
            final fade = CurvedAnimation(
              parent: animation,
              curve: Curves.easeOut,
            );
            final slide = Tween<Offset>(
              begin: const Offset(0.04, 0),
              end: Offset.zero,
            ).animate(fade);
            return SlideTransition(
              position: slide,
              child: FadeTransition(opacity: fade, child: child),
            );
          },
        );

>>>>>>> 221dac99ad6eb8630614390a1cac750a9add04cb
      case RouteNames.authentication:
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => const AuthPlaceholderPage(),
        );
      case RouteNames.root:
        final arguments = settings.arguments;
        if (arguments == null && kDebugMode) {
          return MaterialPageRoute<void>(
            settings: settings,
            builder: (_) =>
                MealAnalysisPage(initialResult: _mealAnalysisPreview),
          );
        }
        if (arguments is! MealAnalysisRouteArguments) {
          return MaterialPageRoute<void>(
            settings: settings,
            builder: (_) => const Scaffold(
              body: Center(
                child: Text('Invalid meal analysis route arguments.'),
              ),
            ),
          );
        }
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => MealAnalysisPage(
            initialResult: arguments.initialResult,
            analysisId: arguments.analysisId,
            userId: arguments.userId,
          ),
        );

      default:
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }

  static final _mealAnalysisPreview = MealAnalysisResult(
    id: 'preview-analysis',
    userId: 'preview-user',
    sourceDescription: 'Grilled chicken with rice and vegetables',
    foodItems: [
      AnalyzedFoodItem(
        name: 'Grilled chicken breast',
        estimatedQuantity: 150,
        quantityUnit: 'g',
        calories: 248,
        proteinGrams: 46.5,
        carbohydrateGrams: 0,
        fatGrams: 5.4,
        confidenceScore: 0.96,
      ),
      AnalyzedFoodItem(
        name: 'Brown rice',
        estimatedQuantity: 180,
        quantityUnit: 'g',
        calories: 200,
        proteinGrams: 4.6,
        carbohydrateGrams: 41.6,
        fatGrams: 1.6,
        confidenceScore: 0.92,
      ),
      AnalyzedFoodItem(
        name: 'Steamed broccoli',
        estimatedQuantity: 100,
        quantityUnit: 'g',
        calories: 35,
        proteinGrams: 2.4,
        carbohydrateGrams: 7.2,
        fatGrams: 0.4,
        confidenceScore: 0.9,
      ),
    ],
    totalCalories: 483,
    totalProteinGrams: 53.5,
    totalCarbohydrateGrams: 48.8,
    totalFatGrams: 7.4,
    analysisSummary:
        'A balanced meal with lean protein, whole grains, and vegetables.',
    nutritionInsights: [
      'High in protein to support muscle maintenance.',
      'Brown rice provides a good source of complex carbohydrates.',
    ],
    warnings: ['Nutrition values are estimates.'],
    confidenceScore: 0.93,
    analyzedAt: DateTime(2026, 10, 27, 12),
  );
}
