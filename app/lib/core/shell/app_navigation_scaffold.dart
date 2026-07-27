import 'package:flutter/material.dart';

import '../responsive/breakpoints.dart';

class AppDestination {
  final IconData icon;
  final IconData selectedIcon;
  final String label;
  final Widget page;

  const AppDestination({
    required this.icon,
    IconData? selectedIcon,
    required this.label,
    required this.page,
  }) : selectedIcon = selectedIcon ?? icon;
}

class AppNavigationScaffold extends StatelessWidget {
  final List<AppDestination> destinations;
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;
  final PreferredSizeWidget? appBar;
  final Widget? floatingActionButton;
  const AppNavigationScaffold({
    super.key,
    required this.destinations,
    required this.selectedIndex,
    required this.onDestinationSelected,
    this.appBar,
    this.floatingActionButton,
  });

  @override
  Widget build(BuildContext context) {
    final body = IndexedStack(
      index: selectedIndex,
      children: destinations.map((d) => d.page).toList(),
    );

    if (context.windowSize.isCompact) {
      return Scaffold(
        appBar: appBar,
        body: body,
        bottomNavigationBar: NavigationBar(
          selectedIndex: selectedIndex,
          onDestinationSelected: onDestinationSelected,
          destinations: [
            for (final destination in destinations)
              NavigationDestination(
                icon: Icon(destination.icon),
                selectedIcon: Icon(destination.selectedIcon),
                label: destination.label,
              ),
          ],
        ),
        floatingActionButton: floatingActionButton,
      );
    }

    final extended = context.windowSize.isExpanded;
    return Scaffold(
      appBar: appBar,
      body: Row(
        children: [
          NavigationRail(
            extended: extended,
            selectedIndex: selectedIndex,
            onDestinationSelected: onDestinationSelected,
            labelType: extended
                ? NavigationRailLabelType.none
                : NavigationRailLabelType.selected,
            destinations: [
              for (final destination in destinations)
                NavigationRailDestination(
                  icon: Icon(destination.icon),
                  selectedIcon: Icon(destination.selectedIcon),
                  label: Text(destination.label),
                ),
            ],
          ),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(child: body),
        ],
      ),
      floatingActionButton: floatingActionButton,
    );
  }
}
