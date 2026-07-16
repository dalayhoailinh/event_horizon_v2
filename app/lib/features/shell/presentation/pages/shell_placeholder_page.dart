import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/route_names.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../auth/presentation/blocs/auth/auth_bloc.dart';
import '../../../auth/presentation/blocs/auth/auth_state.dart';

class ShellPlaceholderPage extends StatelessWidget {
  final String title;
  const ShellPlaceholderPage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthBloc>().state;
    final info = switch (authState) {
      AuthAuthenticated(:final user) =>
        '${user.email}'
            ' - vai trò: ${user.role.name}'
            ' - xác minh email: ${user.emailVerified ? 'rồi' : 'chưa'}',
      _ => 'Khách (chưa đăng nhập)',
    };
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          IconButton(
            tooltip: 'Đăng xuất',
            onPressed: () =>
                context.read<AuthBloc>().add(const AuthLogoutRequested()),
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(title, style: Theme.of(context).textTheme.headlineMedium),
            AppSpacing.vSm,
            Text(info),
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
