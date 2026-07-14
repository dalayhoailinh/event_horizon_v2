import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'core/di/injection.dart';
import 'core/env/app_env.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  if (AppEnv.useEmulator) {
    await _connectToEmulators();
  }
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

Future<void> _connectToEmulators() async {
  final host = (!kIsWeb && defaultTargetPlatform == TargetPlatform.android)
      ? '10.0.2.2'
      : 'localhost';
  await FirebaseAuth.instance.useAuthEmulator(host, 9099);
  FirebaseFirestore.instance.useFirestoreEmulator(host, 8080);
  FirebaseFunctions.instanceFor(
    region: 'asia-southeast1',
  ).useFunctionsEmulator(host, 5001);
  debugPrint('>> Đang dùng EMULATOR tại $host');
}
