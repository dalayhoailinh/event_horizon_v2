import '../../domain/entities/seat_lock.dart';

SeatLock mapSeatLock(String code, Map<Object?, Object?> data) {
  return SeatLock(
    seatCode: code,
    userId: (data['userId'] as String?) ?? '',
    status: (data['status'] as String?) ?? 'selecting',
    expiresAt: (data['expiresAt'] as num?)?.toInt(),
  );
}
