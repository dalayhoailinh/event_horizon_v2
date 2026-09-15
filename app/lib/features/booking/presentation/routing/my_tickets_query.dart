library;

import '../../../../core/router/route_names.dart';
import '../../domain/entities/booking.dart';

enum MyTicketsTab { upcoming, past, cancelled }

const String _qTab = 'tab';

const Map<MyTicketsTab, String> _tabNames = {
  MyTicketsTab.upcoming: 'upcoming',
  MyTicketsTab.past: 'past',
  MyTicketsTab.cancelled: 'cancelled',
};

MyTicketsTab tabFromQuery(Map<String, String> query) {
  final name = query[_qTab];
  for (final entry in _tabNames.entries) {
    if (entry.value == name) return entry.key;
  }
  return MyTicketsTab.upcoming;
}

String myTicketsLocationFor(MyTicketsTab tab) {
  if (tab == MyTicketsTab.upcoming) return RouteNames.myTickets;
  return Uri(
    path: RouteNames.myTickets,
    queryParameters: {_qTab: _tabNames[tab]},
  ).toString();
}

String tabLabel(MyTicketsTab tab) => switch (tab) {
  MyTicketsTab.upcoming => 'Sắp diễn ra',
  MyTicketsTab.past => 'Đã qua',
  MyTicketsTab.cancelled => 'Đã hủy',
};

List<Booking> bookingsForTab(
  List<Booking> all,
  MyTicketsTab tab,
  DateTime now,
) {
  return switch (tab) {
    MyTicketsTab.upcoming => [
      for (final booking in all)
        if (booking.isUpcoming(now)) booking,
    ],
    MyTicketsTab.past => [
      for (final booking in all)
        if (booking.status == BookingStatus.checkedIn ||
            (booking.status == BookingStatus.confirmed &&
                !booking.eventStartAt.isAfter(now)))
          booking,
    ],
    MyTicketsTab.cancelled => [
      for (final booking in all)
        if (booking.status != BookingStatus.confirmed &&
            booking.status != BookingStatus.checkedIn)
          booking,
    ],
  };
}

String emptyLabelFor(MyTicketsTab tab) => switch (tab) {
  MyTicketsTab.upcoming => 'Bạn chưa có vé cho sự kiện sắp tới.',
  MyTicketsTab.past => 'Chưa có vé nào đã qua.',
  MyTicketsTab.cancelled => 'Bạn chưa hủy vé nào.',
};
