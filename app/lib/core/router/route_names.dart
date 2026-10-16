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

  /// Query key of the free-text search on `/events` — shared by the filter
  /// query codec and the header search box so the two can never drift.
  static const String eventsSearchKey = 'search';
  static String eventsSearchPath(String query) =>
      Uri(path: events, queryParameters: {eventsSearchKey: query}).toString();

  static const String eventDetail = ':id';
  static String eventDetailPath(String id) => '/events/$id';
  static const String bookSegment = 'book';
  static String bookPath(String eventId) => '/events/$eventId/book';
  static const String myTickets = '/my-tickets';
  static const String ticketDetailSegment = ':id';
  static String ticketDetailPath(String id, {String? tab}) => Uri(
    path: '/my-tickets/$id',
    queryParameters: tab == null ? null : {'tab': tab},
  ).toString();
  static const String payment = '/pay/:id';
  static String paymentPath(String bookingId) => '/pay/$bookingId';
  static const String seatsSegment = 'seats';
  static String seatsPath(String eventId) => '/events/$eventId/seats';
}
