import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../responsive/breakpoints.dart';
import '../widgets/app_logo.dart';
import 'site_nav.dart';

class AppHeader extends StatelessWidget {
  final List<Widget> actions;

  const AppHeader({super.key, required this.actions});

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    final compact = context.windowSize.isCompact;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: context.shellGutter),
      child: Row(
        children: [
          const Flexible(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: AppLogo(),
            ),
          ),
          Spacer(),
          if (!compact)
            for (final link in kSiteNav)
              _HeaderLink(link: link, active: location == link.route),
          ...actions,
          if (compact)
            IconButton(
              tooltip: 'Menu',
              icon: const Icon(Icons.menu),
              onPressed: Scaffold.of(context).openEndDrawer,
            ),
        ],
      ),
    );
  }
}

class _HeaderLink extends StatelessWidget {
  final NavLink link;
  final bool active;
  const _HeaderLink({required this.link, required this.active});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final route = link.route;
    return TextButton(
      onPressed: route == null ? null : () => context.go(route),
      child: Text(
        link.label,
        style: TextStyle(
          color: active ? scheme.primary : scheme.onSurfaceVariant,
          fontWeight: active ? FontWeight.w600 : FontWeight.w400,
        ),
      ),
    );
  }
}
