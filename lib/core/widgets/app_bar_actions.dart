import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../extensions/context_extensions.dart';
import '../localization/locale_cubit.dart';
import '../responsive/breakpoints.dart';
import '../responsive/responsive_text.dart';
import '../theme/theme_cubit.dart';
import '../theme/theme_dimensions.dart';

class AppBarActions extends StatelessWidget {
  const AppBarActions({
    super.key,
    required this.primary,
    required this.bp,
  });

  final Color primary;
  final AppBreakpoint bp;

  @override
  Widget build(BuildContext context) {
    return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      IconButton(
        constraints: const BoxConstraints(
          minWidth: ThemeDimensions.touchTarget,
          minHeight: ThemeDimensions.touchTarget,
        ),
        onPressed: () {
          context.read<ThemeCubit>().toggleTheme();
        },
        icon: Icon(
          context.isDarkMode
              ? Icons.light_mode_outlined
              : Icons.dark_mode_outlined,
          color: primary,
        ),
      ),
      TextButton.icon(
        style: TextButton.styleFrom(
          minimumSize: const Size(
            ThemeDimensions.touchTarget,
            ThemeDimensions.touchTarget,
          ),
        ),
        onPressed: () {
          String local =
              context
                      .read<LocaleCubit>()
                      .state
                      .languageCode ==
                  'en'
              ? 'ar'
              : 'en';
          context.read<LocaleCubit>().changeLocale(
            Locale(local),
          );
        },
        icon: Icon(Icons.translate, size: 18, color: primary),
        label: AppText(
          context.tr('splashLanguage'),
          baseFontSize: 14,
          breakpoint: bp,
          style: context.textTheme.labelLarge!.copyWith(
            color: primary,
          ),
        ),
      ),
    ],
                );
  }
}
