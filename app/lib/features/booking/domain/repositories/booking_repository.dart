import '../../../../core/result/result.dart';
import '../entities/booking.dart';

abstract interface class BookingRepository {
  Future<Result<String>> createBooking({
    required String eventId,
    required String bookingIntentId,
    required Map<String, int> quantities,
  });
  Future<Result<void>> cancelBooking(String bookingId);
  Stream<List<Booking>> watchMyBookings();
  Stream<Booking?> watchBooking(String bookingId);
}
