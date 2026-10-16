import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/theme/app_spacing.dart';
import '../blocs/auth/auth_bloc.dart';
import '../blocs/auth/auth_state.dart';
import '../blocs/verify_email/verify_email_cubit.dart';
import '../widgets/auth_layout.dart';

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
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final state = context.watch<VerifyEmailCubit>().state;
    final email = switch (context.watch<AuthBloc>().state) {
      AuthAuthenticated(:final user) => user.email,
      _ => '',
    };

    return Title(
      title: 'Xác minh email — EventHorizon',
      color: scheme.primary,
      child: AuthLayout(
        title: 'Xác minh email',
        subtitle: 'Còn một bước nữa là xong',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: CircleAvatar(
                radius: 32,
                backgroundColor: scheme.primaryContainer,
                child: Icon(
                  Icons.mark_email_unread_outlined,
                  size: 32,
                  color: scheme.primary,
                ),
              ),
            ),
            AppSpacing.vMd,
            Text.rich(
              TextSpan(
                children: [
                  const TextSpan(
                    text: 'Chúng tôi đã gửi đường dẫn xác minh tới ',
                  ),
                  TextSpan(
                    text: email,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const TextSpan(
                    text: '. Mở email và bấm vào đường dẫn để tiếp tục.',
                  ),
                ],
              ),
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium,
            ),
            AppSpacing.vLg,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
                AppSpacing.hSm,
                Text(
                  'Trang sẽ tự chuyển khi bạn xác minh xong…',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            if (state.message case final message?)
              AuthMessage(message: message, error: false),
            AppSpacing.vLg,
            OutlinedButton(
              onPressed: state.busy
                  ? null
                  : () => context.read<VerifyEmailCubit>().resend(),
              child: const Text('Gửi lại email'),
            ),
            AppSpacing.vSm,
            TextButton(
              onPressed: () =>
                  context.read<AuthBloc>().add(const AuthLogoutRequested()),
              child: const Text('Dùng tài khoản khác (đăng xuất)'),
            ),
          ],
        ),
      ),
    );
  }
}
