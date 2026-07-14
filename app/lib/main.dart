import 'package:flutter/material.dart';

import 'core/theme/app_spacing.dart';
import 'core/theme/app_theme.dart';

void main() {
  runApp(const EventHorizonApp());
}

class EventHorizonApp extends StatelessWidget {
  const EventHorizonApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Event Horizon v2',
      theme: AppTheme.light,
      home: const _PlaceholderPage(),
    );
  }
}

class _PlaceholderPage extends StatelessWidget {
  const _PlaceholderPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'EventHorizon v2',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            AppSpacing.vSm,
            FilledButton(onPressed: () {}, child: const Text('Nút thử theme')),
            AppSpacing.vSm,
            Text(
              'Đã kết nối',
              style: TextStyle(color: context.statusColors.success),
            ),
          ],
        ),
      ),
    );
  }
}
