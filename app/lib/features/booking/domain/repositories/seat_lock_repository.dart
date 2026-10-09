import '../entities/seat_lock.dart';

abstract interface class SeatLockRepository {
  Stream<Map<String, SeatLock>> watchLocks(String eventId);
}
