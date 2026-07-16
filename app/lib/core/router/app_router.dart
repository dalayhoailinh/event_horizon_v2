import 'package:go_router/go_router.dart';
import 'package:injectable/injectable.dart';

import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/auth/presentation/pages/verify_email_page.dart';
import '../../features/debug/presentation/pages/debug_page.dart';
import '../../features/shell/presentation/pages/shell_placeholder_page.dart';
import 'route_names.dart';

@lazySingleton
class AppRouter {
  late final GoRouter router = GoRouter(
    initialLocation: RouteNames.home,
    routes: [
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
}
