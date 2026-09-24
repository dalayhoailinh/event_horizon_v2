import 'package:event_horizon/core/router/route_names.dart';
import 'package:event_horizon/features/booking/domain/entities/booking.dart';
import 'package:event_horizon/features/booking/presentation/routing/my_tickets_query.dart';
import 'package:flutter_test/flutter_test.dart';

final _now = DateTime(2026, 8, 11, 12);

Booking _booking({
  required String id,
  required BookingStatus status,
  required DateTime startAt,
}) => Booking(
  id: id,
  eventId: 'e1',
  eventTitle: 'Sự kiện $id',
  eventCoverUrl: '',
  eventStartAt: startAt,
  venueName: 'Nhà văn hoá',
  venueAddress: '1 Đường A',
  lineItems: const [],
  totalAmount: 0,
  status: status,
  createdAt: _now,
);

void main() {
  group('URL của tab', () {
    test('tab mặc định -> URL sạch, không có ?tab=', () {
      expect(myTicketsLocationFor(MyTicketsTab.upcoming), '/my-tickets');
    });

    test('đọc rồi ghi lại ra đúng tab ban đầu (round-trip)', () {
      for (final tab in MyTicketsTab.values) {
        final url = Uri.parse(myTicketsLocationFor(tab));
        expect(tabFromQuery(url.queryParameters), tab, reason: '$tab');
      }
    });

    test('tab lạ do sửa tay URL -> về mặc định, không nổ', () {
      expect(tabFromQuery({'tab': 'linh-tinh'}), MyTicketsTab.upcoming);
      expect(tabFromQuery({}), MyTicketsTab.upcoming);
    });
  });

  group('tab đi theo URL sang trang con', () {
    test('tab mặc định -> URL sạch, không có ?tab=', () {
      expect(tabQueryValue(MyTicketsTab.upcoming), isNull);
      expect(RouteNames.ticketDetailPath('bk1'), '/my-tickets/bk1');
    });

    test('tab khác -> URL có ?tab=', () {
      expect(tabQueryValue(MyTicketsTab.cancelled), 'cancelled');
      expect(
        RouteNames.ticketDetailPath('bk1', tab: 'cancelled'),
        '/my-tickets/bk1?tab=cancelled',
      );
    });
  });

  group('lọc theo tab', () {
    final upcoming = _booking(
      id: 'a',
      status: BookingStatus.confirmed,
      startAt: _now.add(const Duration(days: 1)),
    );
    final passed = _booking(
      id: 'b',
      status: BookingStatus.confirmed,
      startAt: _now.subtract(const Duration(days: 1)),
    );
    final checkedIn = _booking(
      id: 'c',
      status: BookingStatus.checkedIn,
      startAt: _now.add(const Duration(days: 1)),
    );
    final cancelled = _booking(
      id: 'd',
      status: BookingStatus.cancelled,
      startAt: _now.add(const Duration(days: 1)),
    );
    final pending = _booking(
      id: 'e',
      status: BookingStatus.pendingPayment,
      startAt: _now.add(const Duration(days: 1)),
    );
    final expired = _booking(
      id: 'f',
      status: BookingStatus.expired,
      startAt: _now.add(const Duration(days: 1)),
    );
    final all = [upcoming, passed, checkedIn, cancelled, pending, expired];

    test('Sắp diễn ra: gồm cả đơn chờ thanh toán', () {
      expect(
        [
          for (final b in bookingsForTab(all, MyTicketsTab.upcoming, _now))
            b.id,
        ],
        ['a', 'e'],
      );
    });

    test('Đã qua: sự kiện đã bắt đầu, HOẶC đã check-in', () {
      expect(
        [for (final b in bookingsForTab(all, MyTicketsTab.past, _now)) b.id],
        ['b', 'c'],
      );
    });

    test('Đã hủy: đơn hết hạn và đơn đã hủy', () {
      expect(
        [
          for (final b in bookingsForTab(all, MyTicketsTab.cancelled, _now))
            b.id,
        ],
        ['d', 'f'],
      );
    });

    test('mỗi vé xuất hiện đúng MỘT tab — không lọt, không trùng', () {
      final seen = <String>[];
      for (final tab in MyTicketsTab.values) {
        seen.addAll([for (final b in bookingsForTab(all, tab, _now)) b.id]);
      }
      expect(seen..sort(), ['a', 'b', 'c', 'd', 'e', 'f']);
    });
  });
}
