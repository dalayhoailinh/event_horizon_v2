import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../theme/app_spacing.dart';
import 'site_nav.dart';

class AppNavDrawer extends StatelessWidget {
  const AppNavDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    return Drawer(
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          children: [
            for (final link in kSiteNav)
              ListTile(
                title: Text(link.label),
                selected: location == link.route,
                onTap: () {
                  Navigator.of(context).pop();
                  context.go(link.route);
                },
              ),
          ],
        ),
      ),
    );
  }
}
