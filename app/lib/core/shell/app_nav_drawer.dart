import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/blocs/auth/auth_bloc.dart';
import '../../features/auth/presentation/blocs/auth/auth_state.dart';
import '../router/route_names.dart';
import '../theme/app_spacing.dart';
import '../widgets/app_logo.dart';
import 'account_menu.dart';
import 'header_search_field.dart';
import 'site_nav.dart';

/// Narrow-window web menu (opened from the header's hamburger).
class AppNavDrawer extends StatelessWidget {
  const AppNavDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    final activeIndex = siteNavIndexOf(location);
    final authState = context.watch<AuthBloc>().state;
    final theme = Theme.of(context);

    void go(String route) {
      Navigator.of(context).pop();
      context.go(route);
    }

    return Drawer(
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: Align(alignment: Alignment.centerLeft, child: AppLogo()),
            ),
            AppSpacing.vMd,
            if (location != RouteNames.events)
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
                child: _DrawerSearch(),
              ),
            AppSpacing.vSm,
            for (var i = 0; i < kSiteNav.length; i++)
              ListTile(
                leading: Icon(
                  i == activeIndex
                      ? kSiteNav[i].selectedIcon
                      : kSiteNav[i].icon,
                ),
                title: Text(kSiteNav[i].label),
                selected: i == activeIndex,
                onTap: switch (kSiteNav[i].route) {
                  null => null,
                  final route => () => go(route),
                },
              ),
            const Divider(height: AppSpacing.xl),
            switch (authState) {
              AuthAuthenticated(:final user) => Column(
                children: [
                  ListTile(
                    leading: UserAvatar(user: user),
                    title: Text(displayNameOf(user)),
                    subtitle: Text(user.email),
                  ),
                  ListTile(
                    leading: Icon(Icons.logout, color: theme.colorScheme.error),
                    title: Text(
                      'Đăng xuất',
                      style: TextStyle(color: theme.colorScheme.error),
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
                      context.read<AuthBloc>().add(const AuthLogoutRequested());
                    },
                  ),
                ],
              ),
              _ => ListTile(
                leading: const Icon(Icons.login),
                title: const Text('Đăng nhập'),
                onTap: () => go(RouteNames.login),
              ),
            },
          ],
        ),
      ),
    );
  }
}

/// The header search box, full width inside the drawer.
class _DrawerSearch extends StatelessWidget {
  const _DrawerSearch();

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.scaleDown,
      alignment: Alignment.centerLeft,
      child: HeaderSearchField(onSearched: () => Navigator.of(context).pop()),
    );
  }
}
