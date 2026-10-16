import 'package:flutter/material.dart';

import '../../../../core/responsive/breakpoints.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_logo.dart';

/// Split screen of the design file: brand on the left (white), the form card
/// on the right (grey). Narrow windows: logo above the card.
class AuthLayout extends StatelessWidget {
  static const double _cardMaxWidth = 440;
  static const String _tagline =
      'Khám phá sự kiện, đặt vé và tận hưởng những khoảnh khắc tuyệt vời';

  final String title;
  final String subtitle;
  final Widget child;

  const AuthLayout({
    super.key,
    required this.title,
    required this.subtitle,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final wide = context.windowSize.isExpanded;

    final card = ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: _cardMaxWidth),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                title,
                textAlign: TextAlign.center,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              AppSpacing.vXs,
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              AppSpacing.vLg,
              child,
            ],
          ),
        ),
      ),
    );

    final formSide = Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!wide) ...[
              // Scale the whole logo (mark + word) together.
              const SizedBox(height: 40, child: FittedBox(child: AppLogo())),
              AppSpacing.vLg,
            ],
            card,
          ],
        ),
      ),
    );

    if (!wide) {
      return Scaffold(body: SafeArea(child: formSide));
    }
    return Scaffold(
      body: Row(
        children: [
          Expanded(
            child: ColoredBox(
              color: theme.colorScheme.surface,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.xl),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(
                        height: 72,
                        child: FittedBox(child: AppLogo()),
                      ),
                      AppSpacing.vMd,
                      Text(
                        _tagline,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Expanded(child: formSide),
        ],
      ),
    );
  }
}

/// Label ABOVE the field (a placeholder alone vanishes while typing — web
/// rule), the field below.
class AuthField extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final TextInputAction textInputAction;
  final ValueChanged<String>? onSubmitted;
  final String? errorText;
  final Iterable<String>? autofillHints;

  const AuthField({
    super.key,
    required this.label,
    required this.hint,
    required this.controller,
    this.keyboardType,
    this.textInputAction = TextInputAction.next,
    this.onSubmitted,
    this.errorText,
    this.autofillHints,
  });

  @override
  Widget build(BuildContext context) {
    return _Labelled(
      label: label,
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        textInputAction: textInputAction,
        onSubmitted: onSubmitted,
        autofillHints: autofillHints,
        decoration: InputDecoration(hintText: hint, errorText: errorText),
      ),
    );
  }
}

/// Password field with a show/hide eye.
class PasswordField extends StatefulWidget {
  final String label;
  final TextEditingController controller;
  final TextInputAction textInputAction;
  final ValueChanged<String>? onSubmitted;
  final String? errorText;
  final Iterable<String>? autofillHints;

  const PasswordField({
    super.key,
    required this.label,
    required this.controller,
    this.textInputAction = TextInputAction.done,
    this.onSubmitted,
    this.errorText,
    this.autofillHints,
  });

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    return _Labelled(
      label: widget.label,
      child: TextField(
        controller: widget.controller,
        obscureText: _obscure,
        textInputAction: widget.textInputAction,
        onSubmitted: widget.onSubmitted,
        autofillHints: widget.autofillHints,
        decoration: InputDecoration(
          hintText: '••••••••',
          errorText: widget.errorText,
          suffixIcon: IconButton(
            tooltip: _obscure ? 'Hiện mật khẩu' : 'Ẩn mật khẩu',
            icon: Icon(
              _obscure
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
            ),
            onPressed: () => setState(() => _obscure = !_obscure),
          ),
        ),
      ),
    );
  }
}

class _Labelled extends StatelessWidget {
  final String label;
  final Widget child;
  const _Labelled({required this.label, required this.child});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(label, style: Theme.of(context).textTheme.labelLarge),
        AppSpacing.vXs,
        child,
      ],
    );
  }
}

/// "──── Hoặc ────".
class OrDivider extends StatelessWidget {
  const OrDivider({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
      child: Row(
        children: [
          const Expanded(child: Divider()),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.smd),
            child: Text(
              'Hoặc',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          const Expanded(child: Divider()),
        ],
      ),
    );
  }
}

/// Outlined "Đăng nhập bằng Google" with a coloured G mark.
class GoogleButton extends StatelessWidget {
  final VoidCallback? onPressed;
  const GoogleButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: scheme.primary),
        foregroundColor: scheme.primary,
      ),
      onPressed: onPressed,
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'G',
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 18,
              color: Color(0xFF4285F4), // Google brand blue (fixed)
            ),
          ),
          AppSpacing.hSm,
          Text('Đăng nhập bằng Google'),
        ],
      ),
    );
  }
}

/// Error/info line shown right above the submit button.
class AuthMessage extends StatelessWidget {
  final String message;
  final bool error;
  const AuthMessage({super.key, required this.message, this.error = true});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final fg = error ? scheme.error : scheme.primary;
    return Container(
      margin: const EdgeInsets.only(top: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.smd),
      decoration: BoxDecoration(
        color: error ? scheme.errorContainer : scheme.primaryContainer,
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            error ? Icons.error_outline : Icons.info_outline,
            size: 18,
            color: fg,
          ),
          AppSpacing.hSm,
          Expanded(
            child: Text(
              message,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: fg),
            ),
          ),
        ],
      ),
    );
  }
}

/// Filled submit button that turns into a spinner while busy.
class SubmitButton extends StatelessWidget {
  final String label;
  final bool busy;
  final VoidCallback onPressed;
  const SubmitButton({
    super.key,
    required this.label,
    required this.busy,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      style: FilledButton.styleFrom(minimumSize: const Size(0, 48)),
      onPressed: busy ? null : onPressed,
      child: busy
          ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : Text(label),
    );
  }
}
