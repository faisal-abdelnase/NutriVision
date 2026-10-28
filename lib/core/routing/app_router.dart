import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// استيراد شاشة الـ Dashboard الخاصة بك (تأكد من مطابقة مسار الملف الفعلي في مشروعك)
import '../../features/dashboard/presentation/screens/dashboard_screen.dart';

import '../../features/meal_analysis/domain/entities/analyzed_food_item.dart';
import '../../features/meal_analysis/domain/entities/meal_analysis_result.dart';
import '../../features/authentication/presentation/screens/login_screen.dart';
import '../../features/meal_analysis/presentation/pages/meal_analysis_page.dart';
import '../../features/onboarding/presentation/pages/onboarding_page.dart';
import '../../features/onboarding/presentation/pages/splash_screen.dart';
import '../../features/authentication/presentation/pages/auth_placeholder_page.dart';
import 'route_names.dart';

class AppRouter {
  AppRouter._();

  static Route<dynamic>? generateRoute(RouteSettings settings) {
    switch (settings.name) {
    // 👇 جعلنا الـ Root والـ Splash يفتحان الـ Dashboard مباشرة
      case RouteNames.root:
      case RouteNames.splash:
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => const DashboardScreen(),
        );

      case RouteNames.onboarding:
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

      case RouteNames.authentication:
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => const AuthPlaceholderPage(),
        );

      case 'meal_analysis': // مسار خاص لو احتجت فتحه مستقبلاً
        final arguments = settings.arguments;
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
}