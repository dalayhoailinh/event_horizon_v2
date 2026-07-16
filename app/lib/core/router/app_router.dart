import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:injectable/injectable.dart';

import '../../features/auth/domain/entities/app_user.dart';
import '../../features/auth/presentation/blocs/auth/auth_bloc.dart';
import '../../features/auth/presentation/blocs/auth/auth_state.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/auth/presentation/pages/splash_page.dart';
import '../../features/auth/presentation/pages/verify_email_page.dart';
import '../../features/debug/presentation/pages/debug_page.dart';
import '../../features/shell/presentation/pages/shell_placeholder_page.dart';
import 'route_names.dart';

class GoRouterRefreshStream extends ChangeNotifier {
  late final StreamSubscription<dynamic> _sub;

  GoRouterRefreshStream(Stream<dynamic> stream) {
    _sub = stream.listen((_) {
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }
}

@lazySingleton
class AppRouter {
  final AuthBloc _authBloc;

  AppRouter(this._authBloc);

  late final GoRouter router = GoRouter(
    initialLocation: RouteNames.splash,
    refreshListenable: GoRouterRefreshStream(_authBloc.stream),
    redirect: _redirect,
    routes: [
      GoRoute(
        path: RouteNames.splash,
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: RouteNames.home,
        builder: (context, state) =>
            const ShellPlaceholderPage(title: 'User shell'),
      ),
      GoRoute(
        path: RouteNames.organizer,
        builder: (context, state) =>
            const ShellPlaceholderPage(title: 'Organizer shell'),
      ),
      GoRoute(
        path: RouteNames.admin,
        builder: (context, state) =>
            const ShellPlaceholderPage(title: 'Admin shell'),
      ),
      GoRoute(
        path: RouteNames.debug,
        builder: (context, state) => const DebugPage(),
      ),
      GoRoute(
        path: RouteNames.login,
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: RouteNames.register,
        builder: (context, state) => const RegisterPage(),
      ),
      GoRoute(
        path: RouteNames.verifyEmail,
        builder: (context, state) => const VerifyEmailPage(),
      ),
    ],
  );

  String? _redirect(BuildContext context, GoRouterState state) {
    final location = state.matchedLocation;
    return switch (_authBloc.state) {
      AuthUnknown() => location == RouteNames.splash ? null : RouteNames.splash,
      AuthUnauthenticated() => switch (location) {
        RouteNames.login || RouteNames.register => null,
        _ => RouteNames.login,
      },
      AuthAuthenticated(:final user) => _redirectSignedIn(user, location),
    };
  }

  String? _redirectSignedIn(AppUser user, String location) {
    if (!user.emailVerified) {
      return location == RouteNames.verifyEmail ? null : RouteNames.verifyEmail;
    }

    final onRetryPages =
        location == RouteNames.splash ||
        location == RouteNames.login ||
        location == RouteNames.register ||
        location == RouteNames.verifyEmail;
    if (onRetryPages) return _homeFor(user.role);

    if (location.startsWith(RouteNames.admin) && user.role != UserRole.admin) {
      return _homeFor(user.role);
    }
    if (location.startsWith(RouteNames.organizer) &&
        user.role != UserRole.organizer) {
      return _homeFor(user.role);
    }
    return null;
  }

  String _homeFor(UserRole role) {
    return switch (role) {
      UserRole.user || UserRole.staff => RouteNames.home,
      UserRole.organizer => RouteNames.organizer,
      UserRole.admin => RouteNames.admin,
    };
  }
}
