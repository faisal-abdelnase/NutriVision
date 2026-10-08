import 'package:flutter/material.dart';

import 'adaptive_navigation.dart';

/// Wraps [body] in the navigation shell appropriate for the current
/// screen size: bottom nav bar on phones, a rail on tablets, and a
/// drawer on desktop. Feature modules pass in their own destinations —
/// this file only knows about structure, not app content.
class AdaptiveScaffold extends StatelessWidget {
  const AdaptiveScaffold({
    super.key,
    required this.destinations,
    required this.selectedIndex,
    required this.onDestinationSelected,
    required this.body,
    this.appBar,
    this.floatingActionButton,
  });

  final List<AdaptiveNavItem> destinations;
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;
  final Widget body;
  final PreferredSizeWidget? appBar;
  final Widget? floatingActionButton;

  @override
  Widget build(BuildContext context) {
    final navType = AdaptiveNavigation.of(context);
    return switch (navType) {
      AdaptiveNavType.bottomBar => _BottomBarShell(scaffold: this),
      AdaptiveNavType.rail => _RailShell(scaffold: this),
      AdaptiveNavType.drawer => _DrawerShell(scaffold: this),
    };
  }
}

class _BottomBarShell extends StatelessWidget {
  const _BottomBarShell({required this.scaffold});
  final AdaptiveScaffold scaffold;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: scaffold.appBar,
      floatingActionButton: scaffold.floatingActionButton,
      body: scaffold.body,
      bottomNavigationBar: NavigationBar(
        selectedIndex: scaffold.selectedIndex,
        onDestinationSelected: scaffold.onDestinationSelected,
        destinations: scaffold.destinations
            .map((d) => NavigationDestination(
                  icon: Icon(d.icon),
                  selectedIcon: Icon(d.selectedIcon),
                  label: d.label,
                ))
            .toList(),
      ),
    );
  }
}

class _RailShell extends StatelessWidget {
  const _RailShell({required this.scaffold});
  final AdaptiveScaffold scaffold;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: scaffold.appBar,
      floatingActionButton: scaffold.floatingActionButton,
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: scaffold.selectedIndex,
            onDestinationSelected: scaffold.onDestinationSelected,
            labelType: NavigationRailLabelType.all,
            destinations: scaffold.destinations
                .map((d) => NavigationRailDestination(
                      icon: Icon(d.icon),
                      selectedIcon: Icon(d.selectedIcon),
                      label: Text(d.label),
                    ))
                .toList(),
          ),
          const VerticalDivider(width: 1),
          Expanded(child: scaffold.body),
        ],
      ),
    );
  }
}

class _DrawerShell extends StatelessWidget {
  const _DrawerShell({required this.scaffold});
  final AdaptiveScaffold scaffold;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: scaffold.appBar,
      floatingActionButton: scaffold.floatingActionButton,
      body: Row(
        children: [
          SizedBox(
            width: 260,
            child: NavigationDrawer(
              selectedIndex: scaffold.selectedIndex,
              onDestinationSelected: scaffold.onDestinationSelected,
              children: scaffold.destinations
                  .map((d) => NavigationDrawerDestination(
                        icon: Icon(d.icon),
                        selectedIcon: Icon(d.selectedIcon),
                        label: Text(d.label),
                      ))
                  .toList(),
            ),
          ),
          const VerticalDivider(width: 1),
          Expanded(child: scaffold.body),
        ],
      ),
    );
  }
}
