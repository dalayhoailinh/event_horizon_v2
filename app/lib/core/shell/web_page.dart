import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../env/app_env.dart';
import '../responsive/breakpoints.dart';
import '../widgets/app_logo.dart';
import 'account_menu.dart';
import 'app_footer.dart';
import 'app_header.dart';
import 'app_nav_drawer.dart';
import 'site_nav.dart';

/// Mobile-app idioms (bottom tabs, back arrow, no footer) vs web idioms
/// (header, footer, one page-long scroll). Decided by PLATFORM, never by
/// width: a narrow browser window is still a web page.
bool useAppShell() => !kIsWeb || AppEnv.forceAppShell;

/// Page frame shared by every user-facing page. Pages only provide content
/// sections; this widget decides which shell wraps them.
class WebPage extends StatelessWidget {
  final List<Widget> sections;
  final String title;
  final List<Widget> actions;
  const WebPage({
    super.key,
    required this.title,
    required this.actions,
    required this.sections,
  });

  @override
  Widget build(BuildContext context) {
    final page = useAppShell()
        ? _AppShellPage(title: title, actions: actions, sections: sections)
        : _WebShellPage(actions: actions, sections: sections);
    return Title(
      title: '$title — EventHorizon',
      color: Theme.of(context).colorScheme.primary,
      child: page,
    );
  }
}

class _WebShellPage extends StatefulWidget {
  final List<Widget> sections;
  final List<Widget> actions;
  const _WebShellPage({required this.actions, required this.sections});

  @override
  State<_WebShellPage> createState() => _WebShellPageState();
}

class _WebShellPageState extends State<_WebShellPage> {
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final compact = context.windowSize.isCompact;
    final wide = context.windowSize.isExpanded;
    final contentMinHeight = MediaQuery.sizeOf(context).height - kToolbarHeight;
    return Scaffold(
      endDrawer: wide ? null : const AppNavDrawer(),
      body: Scrollbar(
        controller: _scrollController,
        thumbVisibility: !compact,
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            SliverAppBar(
              pinned: true,
              toolbarHeight: 64,
              automaticallyImplyLeading: false,
              automaticallyImplyActions: false,
              titleSpacing: 0,
              title: AppHeader(actions: widget.actions),
            ),
            SliverToBoxAdapter(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: contentMinHeight),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: widget.sections,
                ),
              ),
            ),
            const SliverToBoxAdapter(child: AppFooter()),
          ],
        ),
      ),
    );
  }
}

/// Installed-app frame: section roots get bottom tabs, deeper pages get an
/// app bar with a back arrow.
class _AppShellPage extends StatelessWidget {
  final String title;
  final List<Widget> sections;
  final List<Widget> actions;
  const _AppShellPage({
    required this.title,
    required this.actions,
    required this.sections,
  });

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    final isRoot = isSiteNavRoot(location);
    final navIndex = siteNavIndexOf(location);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: isRoot ? null : const _BackToParent(),
        title: isRoot ? const AppLogo() : Text(title),
        actions: [...actions, const AccountMenu(), const SizedBox(width: 8)],
      ),
      body: ListView(padding: EdgeInsets.zero, children: sections),
      bottomNavigationBar: isRoot && navIndex != null
          ? NavigationBar(
              selectedIndex: navIndex,
              onDestinationSelected: (index) {
                final route = kSiteNav[index].route;
                if (route != null) context.go(route);
              },
              destinations: [
                for (final link in kSiteNav)
                  NavigationDestination(
                    icon: Icon(link.icon),
                    selectedIcon: Icon(link.selectedIcon),
                    label: link.label,
                  ),
              ],
            )
          : null,
    );
  }
}

/// Pops when there is a page below; otherwise (deep link, F5) climbs to the
/// section the page belongs to, or home.
class _BackToParent extends StatelessWidget {
  const _BackToParent();

  @override
  Widget build(BuildContext context) {
    return BackButton(
      onPressed: () {
        if (context.canPop()) {
          context.pop();
          return;
        }
        final location = GoRouterState.of(context).matchedLocation;
        final index = siteNavIndexOf(location);
        context.go((index == null ? null : kSiteNav[index].route) ?? '/');
      },
    );
  }
}
