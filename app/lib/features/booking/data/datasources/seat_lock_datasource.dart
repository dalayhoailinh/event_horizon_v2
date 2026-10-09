import 'package:firebase_database/firebase_database.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entities/seat_lock.dart';
import '../models/seat_lock_mappers.dart';

abstract interface class SeatLockDataSource {
  Stream<Map<String, SeatLock>> watchLocks(String eventId);
}

@LazySingleton(as: SeatLockDataSource)
class SeatLockDataSourceImpl implements SeatLockDataSource {
  final FirebaseDatabase _db;

  const SeatLockDataSourceImpl(this._db);

  @override
  Stream<Map<String, SeatLock>> watchLocks(String eventId) {
    return _db.ref('seatLocks/$eventId').onValue.map((event) {
      final raw = event.snapshot.value;
      if (raw is! Map) return const <String, SeatLock>{};
      final locks = <String, SeatLock>{};
      raw.forEach((key, value) {
        if (value is! Map) return;
        final code = key as String;
        locks[code] = mapSeatLock(code, value);
      });
      return locks;
    });
  }
}
