import 'package:flutter/material.dart';

import 'core/di/injection.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';

void main() {
  configureDependencies();
  runApp(const EventHorizonApp());
}

class EventHorizonApp extends StatelessWidget {
  const EventHorizonApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Event Horizon v2',
      theme: AppTheme.light,
      routerConfig: getIt<AppRouter>().router,
    );
  }
}
