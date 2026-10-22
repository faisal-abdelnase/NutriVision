import 'package:flutter/material.dart';
import '../../features/ai_coach/presentation/pages/ai_coach_test_screen.dart';
import '../../features/dashboard/presentation/screens/dashboard_screen.dart';
import 'route_names.dart';


class AppRouter {
  AppRouter._();

  static Route<dynamic>? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteNames.root:
      case RouteNames.splash:
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => AiCoachTestScreen(),
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

      default:
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}