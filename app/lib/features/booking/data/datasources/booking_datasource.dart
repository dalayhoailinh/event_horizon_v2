import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/firebase/functions_error_mapper.dart';
import '../../domain/entities/booking.dart';
import '../../domain/repositories/booking_repository.dart';
import '../models/booking_mappers.dart';

abstract interface class BookingDataSource {
  Future<BookingCreated> createBooking({
    required String eventId,
    required String bookingIntentId,
    required Map<String, int> quantities,
  });
  Future<void> cancelBooking(String bookingId);
  Stream<List<Booking>> watchMyBookings();
  Stream<Booking?> watchBooking(String bookingId);
}

@LazySingleton(as: BookingDataSource)
class BookingDataSourceImpl implements BookingDataSource {
  final FirebaseFirestore _db;
  final FirebaseFunctions _functions;
  final FirebaseAuth _auth;
  const BookingDataSourceImpl(this._db, this._functions, this._auth);

  @override
  Future<BookingCreated> createBooking({
    required String eventId,
    required String bookingIntentId,
    required Map<String, int> quantities,
  }) async {
    try {
      final result = await _functions.httpsCallable('createBooking').call({
        'eventId': eventId,
        'bookingIntentId': bookingIntentId,
        'items': quantities.entries
            .where((e) => e.value > 0)
            .map((e) => {'ticketTypeId': e.key, 'quantity': e.value})
            .toList(),
      });
      final data = Map<String, dynamic>.from(result.data as Map);
      return (
        bookingId: data['bookingId'] as String,
        paymentRequired: (data['paymentRequired'] as bool?) ?? false,
      );
    } on FirebaseFunctionsException catch (e) {
      throw mapFunctionsException(e);
    }
  }

  @override
  Future<void> cancelBooking(String bookingId) async {
    try {
      await _functions.httpsCallable('cancelBooking').call({
        'bookingId': bookingId,
      });
    } on FirebaseFunctionsException catch (e) {
      throw mapFunctionsException(e);
    }
  }

  @override
  Stream<List<Booking>> watchMyBookings() {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return Stream.value(const []);
    return _db
        .collection('bookings')
        .where('userId', isEqualTo: uid)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => mapBooking(doc.id, doc.data()))
              .toList(),
        );
  }

  @override
  Stream<Booking?> watchBooking(String bookingId) {
    return _db
        .collection('bookings')
        .doc(bookingId)
        .snapshots()
        .map(
          (snap) =>
              snap.data() == null ? null : mapBooking(snap.id, snap.data()!),
        );
  }
}
