import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../responsive/breakpoints.dart';
import 'site_nav.dart';

class AppHeader extends StatelessWidget {
  const AppHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    final compact = context.windowSize.isCompact;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: context.shellGutter),
      child: Row(
        children: [
          const Text('Event Horizon'),
          Spacer(),
          if (!compact) ...[
            for (final link in kSiteNav)
              _HeaderLink(link: link, active: location == link.route),
          ],
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
    return TextButton(
      onPressed: () => context.go(link.route),
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
