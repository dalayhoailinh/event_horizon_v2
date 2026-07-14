import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/route_names.dart';
import '../../../../core/theme/app_spacing.dart';

class ShellPlaceholderPage extends StatelessWidget {
  final String title;
  const ShellPlaceholderPage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(title, style: Theme.of(context).textTheme.headlineMedium),
            AppSpacing.vLg,
            FilledButton(
              onPressed: () => context.go(RouteNames.home),
              child: const Text('User shell'),
            ),
            AppSpacing.vSm,
            FilledButton(
              onPressed: () => context.go(RouteNames.organizer),
              child: const Text('Organizer shell'),
            ),
            AppSpacing.vSm,
            FilledButton(
              onPressed: () => context.go(RouteNames.admin),
              child: const Text('Admin shell'),
            ),
            AppSpacing.vLg,
            OutlinedButton(
              onPressed: () => context.go(RouteNames.debug),
              child: const Text('Trang Debug'),
            ),
          ],
        ),
      ),
    );
  }
}
