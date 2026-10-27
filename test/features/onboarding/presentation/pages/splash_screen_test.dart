import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nutri_vision/core/localization/app_localizations.dart';
import 'package:nutri_vision/core/localization/localization_config.dart';
import 'package:nutri_vision/core/routing/route_names.dart';
import 'package:nutri_vision/core/theme/app_theme.dart';
import 'package:nutri_vision/features/onboarding/domain/entities/onboarding_state.dart';
import 'package:nutri_vision/features/onboarding/domain/repositories/onboarding_repository.dart';
import 'package:nutri_vision/features/onboarding/domain/usecases/complete_onboarding.dart';
import 'package:nutri_vision/features/onboarding/domain/usecases/has_completed_onboarding.dart';
import 'package:nutri_vision/features/onboarding/presentation/cubit/onboarding_cubit.dart';
import 'package:nutri_vision/features/onboarding/presentation/pages/splash_screen.dart';

class FakeOnboardingRepository implements OnboardingRepository {
  bool isCompleted;
  bool shouldThrow;

  FakeOnboardingRepository({
    this.isCompleted = false,
    this.shouldThrow = false,
  });

  @override
  Future<OnboardingState> getOnboardingState() async {
    if (shouldThrow) throw Exception('Storage error');
    return OnboardingState(isCompleted: isCompleted);
  }

  @override
  Future<void> completeOnboarding() async {
    isCompleted = true;
  }
}

Widget createTestWidget({required OnboardingCubit cubit}) {
  return BlocProvider<OnboardingCubit>.value(
    value: cubit,
    child: MaterialApp(
      locale: LocalizationConfig.english,
      supportedLocales: LocalizationConfig.supportedLocales,
      localizationsDelegates: LocalizationConfig.delegates,
      theme: AppTheme.light(LocalizationConfig.english),
      routes: {
        RouteNames.onboarding: (_) =>
            const Scaffold(body: Text('OnboardingScreen')),
        RouteNames.authentication: (_) =>
            const Scaffold(body: Text('AuthScreen')),
      },
      home: const SplashScreen(),
    ),
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    AppLocalizations.setMockStrings('en', {
      'error': 'Something went wrong',
      'retry': 'Retry',
    });
  });

  testWidgets('routes to onboarding when not completed', (tester) async {
    final repo = FakeOnboardingRepository(isCompleted: false);
    final cubit = OnboardingCubit(
      hasCompletedOnboarding: HasCompletedOnboarding(repo),
      completeOnboarding: CompleteOnboarding(repo),
    );

    await tester.pumpWidget(createTestWidget(cubit: cubit));
    await tester.pump();

    // Check status
    await cubit.checkOnboardingStatus();
    await tester.pumpAndSettle();

    expect(find.text('OnboardingScreen'), findsOneWidget);
    cubit.close();
  });

  testWidgets('routes to authentication when completed', (tester) async {
    final repo = FakeOnboardingRepository(isCompleted: true);
    final cubit = OnboardingCubit(
      hasCompletedOnboarding: HasCompletedOnboarding(repo),
      completeOnboarding: CompleteOnboarding(repo),
    );

    await tester.pumpWidget(createTestWidget(cubit: cubit));
    await tester.pump();

    await cubit.checkOnboardingStatus();
    await tester.pumpAndSettle();

    expect(find.text('AuthScreen'), findsOneWidget);
    cubit.close();
  });

  testWidgets('shows error view on failure and retrying invokes check', (
    tester,
  ) async {
    final repo = FakeOnboardingRepository(shouldThrow: true);
    final cubit = OnboardingCubit(
      hasCompletedOnboarding: HasCompletedOnboarding(repo),
      completeOnboarding: CompleteOnboarding(repo),
    );

    await tester.pumpWidget(createTestWidget(cubit: cubit));
    await tester.pump();

    await cubit.checkOnboardingStatus();
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.error_outline), findsOneWidget);
    expect(find.text('Retry'), findsOneWidget);

    repo.shouldThrow = false;
    await tester.tap(find.text('Retry'));
    await tester.pumpAndSettle();

    expect(find.text('OnboardingScreen'), findsOneWidget);
    cubit.close();
  });
}
