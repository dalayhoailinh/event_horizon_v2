import 'package:freezed_annotation/freezed_annotation.dart';

part 'booking.freezed.dart';

enum BookingStatus {
  pendingPayment,
  confirmed,
  checkedIn,
  expired,
  cancelled,
  refunding,
  refunded,
  unknown,
}

@freezed
abstract class BookingLineItem with _$BookingLineItem {
  const factory BookingLineItem({
    required String ticketTypeId,
    required String name,
    required int price,
    required int quantity,
  }) = _BookingLineItem;
}

@freezed
abstract class BookingTicket with _$BookingTicket {
  const factory BookingTicket({
    required String qrData,
    required String qrSignature,
  }) = _BookingTicket;
}

@freezed
abstract class Booking with _$Booking {
  const factory Booking({
    required String id,
    required String eventId,
    required String eventTitle,
    required String eventCoverUrl,
    required DateTime eventStartAt,
    required String venueName,
    required String venueAddress,
    required List<BookingLineItem> lineItems,
    required int totalAmount,
    required BookingStatus status,
    required DateTime createdAt,
    BookingTicket? ticket,
    DateTime? expiresAt,
  }) = _Booking;
  const Booking._();

  int get ticketCount {
    var count = 0;
    for (final item in lineItems) {
      count += item.quantity;
    }
    return count;
  }

  bool get isActive =>
      status == BookingStatus.pendingPayment ||
      status == BookingStatus.confirmed ||
      status == BookingStatus.checkedIn;

  bool isUpcoming(DateTime now) =>
      (status == BookingStatus.pendingPayment ||
          status == BookingStatus.confirmed) &&
      eventStartAt.isAfter(now);

  bool canCancel(DateTime now) =>
      status == BookingStatus.confirmed && eventStartAt.isAfter(now);
}
