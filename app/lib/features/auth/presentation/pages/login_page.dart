import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/theme/app_spacing.dart';
import '../blocs/login/login_cubit.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<LoginCubit>(),
      child: const _LoginView(),
    );
  }
}

class _LoginView extends StatefulWidget {
  const _LoginView();

  @override
  State<_LoginView> createState() => __LoginViewState();
}

class __LoginViewState extends State<_LoginView> {
  final _email = TextEditingController();
  final _password = TextEditingController();

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _showForgotPasswordDialog(BuildContext context) async {
    final cubit = context.read<LoginCubit>();
    final controller = TextEditingController(text: _email.text);
    final email = await showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Đặt lại mật khẩu'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(labelText: 'Email'),
          keyboardType: TextInputType.emailAddress,
        ),
        actions: [
          TextButton(
            onPressed: () => dialogContext.pop(),
            child: const Text('Hủy'),
          ),
          FilledButton(
            onPressed: () => dialogContext.pop(controller.text),
            child: const Text('Gửi email'),
          ),
        ],
      ),
    );
    if (email != null && email.isNotEmpty) {
      await cubit.sendPasswordReset(email);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<LoginCubit>().state;
    final theme = Theme.of(context);

    return Scaffold(
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
                  'Đăng nhập',
                  style: theme.textTheme.headlineMedium,
                  textAlign: TextAlign.center,
                ),
                AppSpacing.vLg,
                TextField(
                  controller: _email,
                  decoration: const InputDecoration(labelText: 'Email'),
                  keyboardType: TextInputType.emailAddress,
                ),
                AppSpacing.vMd,
                TextField(
                  controller: _password,
                  decoration: const InputDecoration(labelText: 'Mật khẩu'),
                  obscureText: true,
                ),
                if (state.errorMessage != null) ...[
                  AppSpacing.vMd,
                  Text(
                    state.errorMessage!,
                    style: TextStyle(color: theme.colorScheme.error),
                  ),
                ],
                if (state.infoMessage != null) ...[
                  AppSpacing.vMd,
                  Text(
                    state.infoMessage!,
                    style: TextStyle(color: theme.colorScheme.primary),
                  ),
                ],
                AppSpacing.vLg,
                FilledButton(
                  onPressed: state.submitting
                      ? null
                      : () => context.read<LoginCubit>().loginWithEmail(
                          _email.text,
                          _password.text,
                        ),
                  child: state.submitting
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Đăng nhập'),
                ),
                AppSpacing.vSm,
                OutlinedButton(
                  onPressed: state.submitting
                      ? null
                      : () => context.read<LoginCubit>().loginWithGoogle(),
                  child: const Text('Đăng nhập với Google'),
                ),
                TextButton(
                  onPressed: () => _showForgotPasswordDialog(context),
                  child: const Text('Quên mật khẩu?'),
                ),
                TextButton(
                  onPressed: () => context.go(RouteNames.register),
                  child: const Text('Chưa có tài khoản? Đăng ký'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
