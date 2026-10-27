import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../features/meal_analysis/domain/entities/analyzed_food_item.dart';
import '../../features/meal_analysis/domain/entities/meal_analysis_result.dart';
import '../../features/authentication/presentation/screens/login_screen.dart';
import '../../features/meal_analysis/presentation/pages/meal_analysis_page.dart';
import 'route_names.dart';

class AppRouter {
  AppRouter._();

  static Route<dynamic>? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      // case RouteNames.root:
      case RouteNames.splash:
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => LoginScreen(),
        );
      case RouteNames.onboarding:
      // return MaterialPageRoute<void>(
      //   settings: settings,
      //   builder: (_) => OnboardingPage(repository: onboardingRepository),
      // );
      case RouteNames.authentication:
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => const Placeholder(),
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
