import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/domain/entities/app_user.dart';
import '../../features/auth/presentation/blocs/auth/auth_bloc.dart';
import '../../features/auth/presentation/blocs/auth/auth_state.dart';
import '../router/route_names.dart';
import '../theme/app_spacing.dart';

/// Avatar circle (initial of the name) that opens the account menu; a
/// "Đăng nhập" button for guests.
class AccountMenu extends StatelessWidget {
  const AccountMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthBloc>().state;
    return switch (authState) {
      AuthAuthenticated(:final user) => _AvatarMenu(user: user),
      _ => FilledButton(
        onPressed: () => context.go(RouteNames.login),
        child: const Text('Đăng nhập'),
      ),
    };
  }
}

enum _AccountAction { myTickets, logout }

class _AvatarMenu extends StatelessWidget {
  final AppUser user;
  const _AvatarMenu({required this.user});

  void _onSelected(BuildContext context, _AccountAction action) {
    switch (action) {
      case _AccountAction.myTickets:
        context.go(RouteNames.myTickets);
      case _AccountAction.logout:
        context.read<AuthBloc>().add(const AuthLogoutRequested());
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return PopupMenuButton<_AccountAction>(
      tooltip: 'Tài khoản',
      position: PopupMenuPosition.under,
      onSelected: (action) => _onSelected(context, action),
      itemBuilder: (context) => [
        PopupMenuItem(
          enabled: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                displayNameOf(user),
                style: theme.textTheme.titleSmall?.copyWith(
                  color: theme.colorScheme.onSurface,
                ),
              ),
              Text(
                user.email,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        const PopupMenuDivider(),
        const PopupMenuItem(
          value: _AccountAction.myTickets,
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(Icons.confirmation_num_outlined),
            title: Text('Vé của tôi'),
          ),
        ),
        PopupMenuItem(
          value: _AccountAction.logout,
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(Icons.logout, color: theme.colorScheme.error),
            title: Text(
              'Đăng xuất',
              style: TextStyle(color: theme.colorScheme.error),
            ),
          ),
        ),
      ],
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xs),
        child: UserAvatar(user: user),
      ),
    );
  }
}

/// Filled circle with the first letter of the user's name (or email).
class UserAvatar extends StatelessWidget {
  static const double defaultSize = 36;

  final AppUser user;
  final double size;
  const UserAvatar({super.key, required this.user, this.size = defaultSize});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return CircleAvatar(
      radius: size / 2,
      backgroundColor: scheme.primary,
      child: Text(
        initialOf(user),
        style: TextStyle(
          color: scheme.onPrimary,
          fontWeight: FontWeight.w700,
          fontSize: size * 0.42,
        ),
      ),
    );
  }
}

String displayNameOf(AppUser user) {
  final name = user.displayName.trim();
  if (name.isNotEmpty) return name;
  final email = user.email.trim();
  final at = email.indexOf('@');
  return at > 0 ? email.substring(0, at) : 'Tài khoản';
}

String initialOf(AppUser user) {
  final source = displayNameOf(user);
  return source.isEmpty ? 'U' : source.characters.first.toUpperCase();
}
