abstract final class RouteNames {
  static const String home = '/';
  static const String organizer = '/organizer';
  static const String admin = '/admin';
  static const String debug = '/debug'; // dev-only playground
  static const String login = '/login';
  static const String register = '/register';
  static const String verifyEmail = '/verify-email';
  static const String splash = '/splash';
  static const String events = '/events';
  static const String eventDetail = '/events/:id';
  static String eventDetailPath(String id) => '/events/$id';
}
