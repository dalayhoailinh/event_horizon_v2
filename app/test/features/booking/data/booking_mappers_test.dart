import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_horizon/features/booking/data/models/booking_mappers.dart';
import 'package:event_horizon/features/booking/domain/entities/booking.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final fixture = {
    'userId': 'u1',
    'eventId': 'evt007',
    'eventSnapshot': {
      'title': 'Đêm nhạc',
      'coverImageUrl': '',
      'startAt': Timestamp.fromDate(DateTime(2026, 8, 1, 19, 30)),
      'endAt': Timestamp.fromDate(DateTime(2026, 8, 1, 22)),
      'venueName': 'Nhà văn hoá',
      'venueAddress': '1 Đường A',
    },
    'lineItems': [
      {'ticketTypeId': 't1', 'name': 'Vé mời', 'price': 0, 'quantity': 2},
    ],
    'totalAmount': 0,
    'status': 'confirmed',
    'createdAt': Timestamp.fromDate(DateTime(2026, 7, 7)),
    'ticket': {'qrData': 'a.b.1', 'qrSignature': 'deadbeef'},
  };

  test('mapBooking đọc đủ snapshot + lineItems + ticket', () {
    final booking = mapBooking('bk1', fixture);
    expect(booking.eventTitle, 'Đêm nhạc');
    expect(booking.ticketCount, 2);
    expect(booking.status, BookingStatus.confirmed);
    expect(booking.ticket?.qrData, 'a.b.1');
  });

  test('status lạ từ server -> unknown, không crash', () {
    final booking = mapBooking('bk1', {...fixture, 'status': 'tuong-lai'});
    expect(booking.status, BookingStatus.unknown);
  });

  test('isUpcoming nhận now làm tham số', () {
    final booking = mapBooking('bk1', fixture);
    expect(booking.isUpcoming(DateTime(2026, 7, 7)), true);
    expect(booking.isUpcoming(DateTime(2026, 9, 1)), false);
  });

  test('expiresAt: đơn trả phí có hạn, đơn miễn phí là null', () {
    final deadline = DateTime(2026, 8, 1, 19, 45);
    final paid = mapBooking('bk2', {
      ...fixture,
      'status': 'pendingPayment',
      'expiresAt': Timestamp.fromDate(deadline),
    });
    expect(paid.expiresAt, deadline);
    expect(mapBooking('bk1', fixture).expiresAt, isNull);
  });
}
