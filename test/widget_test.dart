import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:nutri_vision/app.dart';
import 'package:nutri_vision/core/di/onboarding_injection.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() async {
    await GetIt.instance.reset();
  });

  tearDown(() async {
    await GetIt.instance.reset();
  });

  testWidgets('NutriVision app smoke test builds correctly', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    await registerOnboardingDependencies();
    final preferences = await SharedPreferences.getInstance();

    await tester.pumpWidget(NutriVision(preferences: preferences));
    await tester.pump();

    expect(find.byType(NutriVision), findsOneWidget);
  });
}
