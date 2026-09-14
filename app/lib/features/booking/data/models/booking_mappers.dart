import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/booking.dart';

BookingStatus bookingStatusFrom(String raw) => switch (raw) {
  'pendingPayment' => BookingStatus.pendingPayment,
  'confirmed' => BookingStatus.confirmed,
  'checkedIn' => BookingStatus.checkedIn,
  'expired' => BookingStatus.expired,
  'cancelled' => BookingStatus.cancelled,
  'refunding' => BookingStatus.refunding,
  'refunded' => BookingStatus.refunded,
  _ => BookingStatus.unknown,
};

Booking mapBooking(String id, Map<String, dynamic> data) {
  final snapshot = (data['eventSnapshot'] as Map<String, dynamic>?) ?? const {};
  final ticket = data['ticket'] as Map<String, dynamic>?;
  return Booking(
    id: id,
    eventId: data['eventId'] as String? ?? '',
    eventTitle: snapshot['title'] as String? ?? '',
    eventCoverUrl: snapshot['coverImageUrl'] as String? ?? '',
    eventStartAt: (snapshot['startAt'] as Timestamp).toDate(),
    venueName: snapshot['venueName'] as String? ?? '',
    venueAddress: snapshot['venueAddress'] as String? ?? '',
    lineItems: ((data['lineItems'] as List?) ?? const []).map((raw) {
      final e = Map<String, dynamic>.from(raw as Map);
      return BookingLineItem(
        ticketTypeId: e['ticketTypeId'] as String? ?? '',
        name: e['name'] as String? ?? '',
        price: (e['price'] as num?)?.toInt() ?? 0,
        quantity: (e['quantity'] as num?)?.toInt() ?? 0,
      );
    }).toList(),
    totalAmount: (data['totalAmount'] as num?)?.toInt() ?? 0,
    status: bookingStatusFrom(data['status'] as String? ?? ''),
    createdAt: (data['createdAt'] as Timestamp).toDate(),
    ticket: ticket == null
        ? null
        : BookingTicket(
            qrData: ticket['qrData'] as String? ?? '',
            qrSignature: ticket['qrSignature'] as String? ?? '',
          ),
  );
}
