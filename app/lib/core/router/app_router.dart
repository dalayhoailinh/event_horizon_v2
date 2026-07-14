import 'package:go_router/go_router.dart';
import 'package:injectable/injectable.dart';

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
    ],
  );
}
