import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/theme/app_spacing.dart';
import '../blocs/login/login_cubit.dart';
import '../widgets/auth_layout.dart';

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

  void _submit() {
    final cubit = context.read<LoginCubit>();
    if (cubit.state.submitting) return;
    cubit.loginWithEmail(_email.text, _password.text);
  }

  Future<void> _showForgotPasswordDialog(BuildContext context) async {
    final cubit = context.read<LoginCubit>();
    final controller = TextEditingController(text: _email.text);
    final email = await showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Đặt lại mật khẩu'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Nhập email, chúng tôi sẽ gửi đường dẫn đặt lại.'),
            AppSpacing.vMd,
            TextField(
              controller: controller,
              autofocus: true,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(hintText: 'Email của bạn'),
              onSubmitted: (value) => dialogContext.pop(value),
            ),
          ],
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
    controller.dispose();
    if (email != null && email.trim().isNotEmpty) {
      await cubit.sendPasswordReset(email.trim());
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<LoginCubit>().state;
    final theme = Theme.of(context);

    return Title(
      title: 'Đăng nhập — EventHorizon',
      color: theme.colorScheme.primary,
      child: AuthLayout(
        title: 'Chào mừng trở lại',
        subtitle: 'Đăng nhập vào tài khoản của bạn',
        child: AutofillGroup(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AuthField(
                label: 'Email',
                hint: 'Nhập email của bạn',
                controller: _email,
                keyboardType: TextInputType.emailAddress,
                autofillHints: const [AutofillHints.email],
              ),
              AppSpacing.vMd,
              PasswordField(
                label: 'Mật khẩu',
                controller: _password,
                autofillHints: const [AutofillHints.password],
                // Enter submits (web rule).
                onSubmitted: (_) => _submit(),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => _showForgotPasswordDialog(context),
                  child: const Text('Quên mật khẩu?'),
                ),
              ),
              if (state.errorMessage case final message?)
                AuthMessage(message: message),
              if (state.infoMessage case final message?)
                AuthMessage(message: message, error: false),
              AppSpacing.vMd,
              SubmitButton(
                label: 'Đăng nhập',
                busy: state.submitting,
                onPressed: _submit,
              ),
              const OrDivider(),
              GoogleButton(
                onPressed: state.submitting
                    ? null
                    : () => context.read<LoginCubit>().loginWithGoogle(),
              ),
              AppSpacing.vMd,
              _SwitchLink(
                question: 'Chưa có tài khoản?',
                action: 'Đăng ký ngay',
                onTap: () => context.go(RouteNames.register),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SwitchLink extends StatelessWidget {
  final String question;
  final String action;
  final VoidCallback onTap;
  const _SwitchLink({
    required this.question,
    required this.action,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          question,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        TextButton(onPressed: onTap, child: Text(action)),
      ],
    );
  }
}
