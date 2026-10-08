import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../adaptive/adaptive_navigation.dart';
import '../adaptive/adaptive_scaffold.dart';
import '../extensions/context_extensions.dart';
import '../localization/locale_cubit.dart';
import '../responsive/breakpoints.dart';
import '../responsive/responsive_builder.dart';
import '../responsive/responsive_text.dart';
import '../theme/app_button_styles.dart';
import '../theme/theme_cubit.dart';
import 'route_names.dart';

/// Minimal routing foundation. Feature `case` branches are added to
/// [generateRoute] as each screen is implemented — for now there is only
/// a placeholder for [RouteNames.root] so the app has somewhere to boot
/// into while screens are being built from the Stitch designs.
///
/// Wire it up in `MaterialApp`:
/// ```dart
/// MaterialApp(
///   initialRoute: RouteNames.root,
///   onGenerateRoute: AppRouter.generateRoute,
/// )
/// ```
class AppRouter {
  AppRouter._();

  static Route<dynamic>? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteNames.root:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const _PlaceholderPage(),
        );
      default:
        return null;
    }
  }
}

class _PlaceholderPage extends StatelessWidget {
  const _PlaceholderPage();

  @override
  Widget build(BuildContext context) {


    // return AdaptiveScaffold(
    //   destinations: [
    //     AdaptiveNavItem(icon: Icons.home, selectedIcon: Icons.home, label: "Home"),
    //     AdaptiveNavItem(icon: Icons.chat, selectedIcon: Icons.chat, label: "Chat"),
    //     AdaptiveNavItem(icon: Icons.person, selectedIcon: Icons.person, label: "Profile"),
    //   ],
    //   selectedIndex: 0,
    //   onDestinationSelected: (value) {
        
    //   },

    //   body: Center(
    //     child: Column(
    //       children: [
    //         Text("Faisal", style: TextStyle(fontSize: 10),),
    //         AppText("Fasial", baseFontSize: 10, breakpoint: Breakpoints.of(context.screenWidth))
    //       ],
    //     ),
    //   ),
    // );




    ///////////////////////////////////////////
    return Scaffold(

      body: Column(
        children: [
          Row(
            children: [
              ElevatedButton(
                onPressed: (){
                  context.read<LocaleCubit>().changeLocale(Locale("en"));
                }, 
                child: Text("EN")),

                ElevatedButton(
                onPressed: (){
                  context.read<LocaleCubit>().changeLocale(Locale("ar"));
                }, 
                child: Text("AR")),


                ElevatedButton(
                  style: AppButtonStyles.text(Theme.of(context).colorScheme,),
                onPressed: (){
                  context.read<ThemeCubit>().toggleTheme();
                }, 
                child: Text(context.isDarkMode ? "light" : "dark")),

              
            ],
          ),
          SizedBox(height: 30,),

          TextField(),
          Center(child: Text(context.tr('save'))),

          SizedBox(height: 30,),

          AppResponsiveBuilder(
            mobile: (context, breakpoint){
              return Text("Mobile");
            },
            tablet: (context, breakpoint){
              return Text("Tablet");
            },

            desktop: (context, breakpoint){
              return Text("Desktop");
            },
            ),

        ],
      ),
    );
  }
}


