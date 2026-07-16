import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'EventHorizon',
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            AppSpacing.vLg,
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
