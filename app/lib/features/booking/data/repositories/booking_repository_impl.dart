import 'package:injectable/injectable.dart';

import '../../../../core/result/guard.dart';
import '../../../../core/result/result.dart';
import '../../domain/entities/booking.dart';
import '../../domain/entities/booking_item_input.dart';
import '../../domain/entities/seat_map.dart';
import '../../domain/repositories/booking_repository.dart';
import '../datasources/booking_datasource.dart';

@LazySingleton(as: BookingRepository)
class BookingRepositoryImpl implements BookingRepository {
  final BookingDataSource _ds;
  const BookingRepositoryImpl(this._ds);

  @override
  Future<Result<BookingCreated>> createBooking({
    required String eventId,
    required String bookingIntentId,
    required List<BookingItemInput> items,
  }) => guard(
    () => _ds.createBooking(
      eventId: eventId,
      bookingIntentId: bookingIntentId,
      items: items,
    ),
  );

  @override
  Future<Result<void>> cancelBooking(String bookingId) =>
      guard(() => _ds.cancelBooking(bookingId));

  @override
  Future<Result<String>> createPayosOrder(String bookingId) =>
      guard(() => _ds.createPayosOrder(bookingId));

  @override
  Stream<List<Booking>> watchMyBookings() => _ds.watchMyBookings();

  @override
  Stream<Booking?> watchBooking(String bookingId) =>
      _ds.watchBooking(bookingId);

  @override
  Future<Result<List<SeatMapFloor>>> fetchSeatMap(String eventId) =>
      guard(() => _ds.fetchSeatMap(eventId));
}
