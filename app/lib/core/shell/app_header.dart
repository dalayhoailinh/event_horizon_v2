import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../responsive/breakpoints.dart';
import '../router/route_names.dart';
import '../theme/app_spacing.dart';
import '../widgets/app_logo.dart';
import 'account_menu.dart';
import 'header_search_field.dart';
import 'site_nav.dart';

/// Web header: logo left, section links centred, search + account right.
/// Narrow windows fold the links into the end drawer (web idiom: hamburger,
/// never bottom tabs).
class AppHeader extends StatelessWidget {
  /// Below this width the header search box would squeeze the links.
  static const double _searchMinWidth = 1100;

  final List<Widget> actions;

  const AppHeader({super.key, required this.actions});

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    final width = MediaQuery.sizeOf(context).width;
    final wide = context.windowSize.isExpanded;
    // "Khám phá" has its own big search bar; a second one in the header is
    // noise (same as the design file's Explore frame).
    final showSearch =
        width >= _searchMinWidth && location != RouteNames.events;

    if (!wide) {
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
            const Spacer(),
            ...actions,
            IconButton(
              tooltip: 'Menu',
              icon: const Icon(Icons.menu),
              onPressed: Scaffold.of(context).openEndDrawer,
            ),
          ],
        ),
      );
    }

    final activeIndex = siteNavIndexOf(location);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: context.shellGutter),
      child: Row(
        children: [
          const Expanded(
            child: Align(alignment: Alignment.centerLeft, child: AppLogo()),
          ),
          for (var i = 0; i < kSiteNav.length; i++)
            _NavTab(link: kSiteNav[i], active: i == activeIndex),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ...actions,
                if (showSearch) ...[const HeaderSearchField(), AppSpacing.hMd],
                const AccountMenu(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _NavTab extends StatefulWidget {
  final NavLink link;
  final bool active;
  const _NavTab({required this.link, required this.active});

  @override
  State<_NavTab> createState() => _NavTabState();
}

class _NavTabState extends State<_NavTab> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final route = widget.link.route;
    final highlighted = widget.active || _hovered;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.smd),
      child: MouseRegion(
        cursor: route == null
            ? SystemMouseCursors.basic
            : SystemMouseCursors.click,
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: GestureDetector(
          onTap: route == null ? null : () => context.go(route),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  width: 2,
                  color: widget.active ? scheme.primary : Colors.transparent,
                ),
              ),
            ),
            child: Text(
              widget.link.label,
              style: theme.textTheme.titleMedium?.copyWith(
                color: highlighted ? scheme.primary : scheme.onSurface,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
