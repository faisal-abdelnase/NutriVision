import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nutri_vision/features/meal_analysis/presentation/cubit/meal_analysis_cubit.dart';
import 'package:nutri_vision/features/onboarding/presentation/cubit/onboarding_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/di/auth_dependencies.dart';
import 'core/di/dashboard_injection.dart';
import 'core/localization/locale_cubit.dart';
import 'core/localization/localization_config.dart';
import 'core/routing/app_router.dart';
import 'core/routing/route_names.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_cubit.dart';
import 'features/authentication/presentation/cubit/auth_cubit.dart';
import 'features/profile/presentation/cubit/profile_cubit.dart';



class NutriVision extends StatelessWidget {
  const NutriVision({super.key, required this.preferences});

  final SharedPreferences preferences;
  

  @override
  Widget build(BuildContext context) { 
    
    return MultiBlocProvider(
    providers: [
      BlocProvider(create: (_) => ThemeCubit(preferences)),
      BlocProvider(create: (_) => LocaleCubit(preferences)),
      BlocProvider(
        create: (_) {
          final authDependencies = AuthDependencies();
          return AuthCubit(
          signInUseCase: authDependencies.signIn,
          signUpUseCase: authDependencies.signUp,
          signOutUseCase: authDependencies.signOut,
          sendPasswordResetEmailUseCase:
              authDependencies.sendPasswordResetEmail,
        );
        }
      ),

      BlocProvider(
      create: (_) => sl<OnboardingCubit>()
        ..checkOnboardingStatus(),
    ), 

    BlocProvider(
      create: (_) => sl<ProfileCubit>()
        ..loadProfile(FirebaseAuth.instance.currentUser!.uid),
      
    ),

    BlocProvider<MealAnalysisCubit>(
          create: (_) => sl<MealAnalysisCubit>(),
        ),
    ],
    child: BlocBuilder<LocaleCubit, Locale>(
      builder: (context, locale) => BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) => MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light(locale),
          darkTheme: AppTheme.dark(locale),
          themeMode: themeMode,
          locale: locale,
          supportedLocales: LocalizationConfig.supportedLocales,
          localizationsDelegates: LocalizationConfig.delegates,
          localeResolutionCallback: LocalizationConfig.resolveLocale,
          initialRoute: RouteNames.root,
          onGenerateRoute: (settings) => AppRouter.generateRoute(settings),
        ),
      ),
    ),
  );
}
}