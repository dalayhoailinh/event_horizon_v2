import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/theme/app_spacing.dart';
import '../blocs/auth/auth_bloc.dart';
import '../blocs/auth/auth_state.dart';
import '../blocs/verify_email/verify_email_cubit.dart';

class VerifyEmailPage extends StatelessWidget {
  const VerifyEmailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<VerifyEmailCubit>()..startWatching(),
      child: const _VerifyEmailView(),
    );
  }
}

class _VerifyEmailView extends StatelessWidget {
  const _VerifyEmailView();

  @override
  Widget build(BuildContext context) {
    final state = context.watch<VerifyEmailCubit>().state;
    final email = switch (context.watch<AuthBloc>().state) {
      AuthAuthenticated(:final user) => user.email,
      _ => null,
    };

    return Scaffold(
      appBar: AppBar(
        title: const Text('Xác minh email'),
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
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Đã gửi email xác minh tới:\n$email',
                  textAlign: TextAlign.center,
                ),
                AppSpacing.vLg,
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                    AppSpacing.hSm,
                    Text('Đang chờ xác minh…'),
                  ],
                ),
                AppSpacing.vLg,
                OutlinedButton(
                  onPressed: state.busy
                      ? null
                      : () => context.read<VerifyEmailCubit>().resend(),
                  child: const Text('Gửi lại email'),
                ),
                if (state.message != null) ...[
                  AppSpacing.vMd,
                  Text(state.message!, textAlign: TextAlign.center),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
