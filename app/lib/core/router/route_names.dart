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
  static const String eventDetail = ':id';
  static String eventDetailPath(String id) => '/events/$id';
  static const String bookSegment = 'book';
  static String bookPath(String eventId) => '/events/$eventId/book';
  static const String myTickets = '/my-tickets';
  static const String ticketDetailSegment = ':id';
  static String ticketDetailPath(String id) => '/my-tickets/$id';
  static const String payment = '/pay/:id';
  static String paymentPath(String bookingId) => '/pay/$bookingId';
}
