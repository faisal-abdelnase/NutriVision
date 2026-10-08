import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/localization/locale_cubit.dart';
import 'core/localization/localization_config.dart';
import 'core/routing/app_router.dart';
import 'core/routing/route_names.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_cubit.dart';

class NutriVision extends StatelessWidget {
  const NutriVision({super.key, required this.preferences});

  final SharedPreferences preferences;

  @override
  Widget build(BuildContext context) => MultiBlocProvider(
    providers: [
      BlocProvider(create: (_) => ThemeCubit(preferences)),
      BlocProvider(create: (_) => LocaleCubit(preferences)),
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
          onGenerateRoute: AppRouter.generateRoute,
        ),
      ),
    ),
  );
}