import 'package:injectable/injectable.dart';

import '../../../../core/result/guard.dart';
import '../../../../core/result/result.dart';
import '../../domain/entities/seat_lock.dart';
import '../../domain/repositories/seat_lock_repository.dart';
import '../datasources/seat_lock_datasource.dart';

@LazySingleton(as: SeatLockRepository)
class SeatLockRepositoryImpl implements SeatLockRepository {
  final SeatLockDataSource _ds;

  const SeatLockRepositoryImpl(this._ds);

  @override
  Stream<Map<String, SeatLock>> watchLocks(String eventId) =>
      _ds.watchLocks(eventId);

  @override
  Future<Result<void>> lockSeat(String eventId, String seatCode) =>
      guard(() => _ds.lockSeat(eventId, seatCode));

  @override
  Future<Result<void>> unlockSeat(String eventId, String seatCode) =>
      guard(() => _ds.unlockSeat(eventId, seatCode));
}
