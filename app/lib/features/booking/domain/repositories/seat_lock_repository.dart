import '../../../../core/result/result.dart';
import '../entities/seat_lock.dart';

const Duration kSeatHoldWhileSelecting = Duration(minutes: 1);
const Duration kSeatHoldForPayment = Duration(minutes: 4);

abstract interface class SeatLockRepository {
  Stream<Map<String, SeatLock>> watchLocks(String eventId);
  Future<Result<void>> lockSeat(String eventId, String seatCode);
  Future<Result<void>> unlockSeat(String eventId, String seatCode);
  Future<Result<void>> releaseAll(String eventId, List<String> seatCodes);
  Future<Result<void>> extendLocks(String eventId, List<String> seatCodes);
  Future<Result<void>> cancelAutoRelease(
    String eventId,
    List<String> seatCodes,
  );
}
