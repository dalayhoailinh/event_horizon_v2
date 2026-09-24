import '../../../../core/result/result.dart';
import '../entities/booking.dart';

typedef BookingCreated = ({String bookingId, bool paymentRequired});

abstract interface class BookingRepository {
  Future<Result<BookingCreated>> createBooking({
    required String eventId,
    required String bookingIntentId,
    required Map<String, int> quantities,
  });
  Future<Result<void>> cancelBooking(String bookingId);
  Future<Result<String>> createPayosOrder(String bookingId);
  Stream<List<Booking>> watchMyBookings();
  Stream<Booking?> watchBooking(String bookingId);
}
