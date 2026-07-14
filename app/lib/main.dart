import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'core/di/injection.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  debugPrint('Firebase OK: ${Firebase.app().options.projectId}');
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
