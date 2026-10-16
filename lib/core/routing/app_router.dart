import 'package:flutter/material.dart';
import 'route_names.dart';

class AppRouter {
  AppRouter._();

  static Route<dynamic>? generateRoute(
    RouteSettings settings) {
    switch (settings.name) {
      case RouteNames.root:
      case RouteNames.splash:
        // return MaterialPageRoute<void>(
        //   settings: settings,
        //   builder: (_) => LoginButton(
        //     email: 'test@example.com',
        //     password: 'YourTestPassword123!',
        //   )
        // );
      case RouteNames.onboarding:
        // return MaterialPageRoute<void>(
        //   settings: settings,
        //   builder: (_) => OnboardingPage(repository: onboardingRepository),
        // );
      case RouteNames.authentication:
        // return MaterialPageRoute<void>(
        //   settings: settings,
        //   builder: (_) => const SplashPage(authenticationRequired: true),
        // );
      default:
        return null;
    }
  }
}
