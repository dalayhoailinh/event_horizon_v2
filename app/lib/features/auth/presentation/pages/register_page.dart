import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/theme/app_spacing.dart';
import '../blocs/register/register_cubit.dart';
import '../widgets/auth_layout.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<RegisterCubit>(),
      child: const _RegisterView(),
    );
  }
}

class _RegisterView extends StatefulWidget {
  const _RegisterView();

  @override
  State<_RegisterView> createState() => __RegisterViewState();
}

class __RegisterViewState extends State<_RegisterView> {
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();

  /// Shown under "Nhập lại mật khẩu" — checked here, before any request.
  String? _confirmError;

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    _confirm.dispose();
    super.dispose();
  }

  void _submit() {
    final cubit = context.read<RegisterCubit>();
    if (cubit.state.submitting) return;
    if (_confirm.text != _password.text) {
      setState(() => _confirmError = 'Mật khẩu nhập lại không khớp.');
      return;
    }
    setState(() => _confirmError = null);
    cubit.submit(
      displayName: _name.text,
      email: _email.text,
      password: _password.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<RegisterCubit>().state;
    final theme = Theme.of(context);

    return Title(
      title: 'Đăng ký — EventHorizon',
      color: theme.colorScheme.primary,
      child: AuthLayout(
        title: 'Tạo tài khoản',
        subtitle: 'Trở thành thành viên của Event Horizon hôm nay',
        child: AutofillGroup(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AuthField(
                label: 'Họ và tên',
                hint: 'Nhập họ và tên của bạn',
                controller: _name,
                autofillHints: const [AutofillHints.name],
              ),
              AppSpacing.vMd,
              AuthField(
                label: 'Email',
                hint: 'Nhập email của bạn',
                controller: _email,
                keyboardType: TextInputType.emailAddress,
                autofillHints: const [AutofillHints.email],
              ),
              AppSpacing.vMd,
              PasswordField(
                label: 'Mật khẩu (tối thiểu 6 ký tự)',
                controller: _password,
                textInputAction: TextInputAction.next,
                autofillHints: const [AutofillHints.newPassword],
              ),
              AppSpacing.vMd,
              PasswordField(
                label: 'Nhập lại mật khẩu',
                controller: _confirm,
                errorText: _confirmError,
                autofillHints: const [AutofillHints.newPassword],
                onSubmitted: (_) => _submit(),
              ),
              if (state.errorMessage case final message?)
                AuthMessage(message: message),
              AppSpacing.vLg,
              SubmitButton(
                label: 'Đăng ký',
                busy: state.submitting,
                onPressed: _submit,
              ),
              AppSpacing.vMd,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Đã có tài khoản?',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  TextButton(
                    onPressed: () => context.go(RouteNames.login),
                    child: const Text('Đăng nhập ngay'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
