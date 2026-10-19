import 'package:flutter/material.dart';
import '../../features/meal_tracking/addmeal/screens/add_meal_screen.dart';
import 'route_names.dart';

// قم بالتأكد من صحة مسار استيراد ملف AddMealScreen الخاص بك

class AppRouter {
  AppRouter._();

  static Route<dynamic>? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteNames.root:
      case RouteNames.splash:
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => const AddMealScreen(), // 👈 سيتم فتح الشاشة التي أنشأتها مباشرة
        );

      case RouteNames.onboarding:
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => const Placeholder(),
        );

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