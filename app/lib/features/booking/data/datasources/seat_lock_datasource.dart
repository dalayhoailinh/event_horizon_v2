import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/result/app_exception.dart';
import '../../domain/entities/seat_lock.dart';
import '../../domain/repositories/seat_lock_repository.dart';
import '../models/seat_lock_mappers.dart';

abstract interface class SeatLockDataSource {
  Stream<Map<String, SeatLock>> watchLocks(String eventId);
  Future<void> lockSeat(String eventId, String seatCode);
  Future<void> unlockSeat(String eventId, String seatCode);
}

@LazySingleton(as: SeatLockDataSource)
class SeatLockDataSourceImpl implements SeatLockDataSource {
  final FirebaseDatabase _db;
  final FirebaseAuth _auth;

  const SeatLockDataSourceImpl(this._db, this._auth);

  DatabaseReference _seatRef(String eventId, String seatCode) {
    return _db.ref('seatLocks/$eventId/$seatCode');
  }

  String _uid() {
    final uid = _auth.currentUser?.uid;
    if (uid == null) throw const AuthException('Bạn cần đăng nhập.');
    return uid;
  }

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

  @override
  Future<void> lockSeat(String eventId, String seatCode) async {
    try {
      await _seatRef(eventId, seatCode).set({
        'userId': _uid(),
        'status': 'selecting',
        'expiresAt': DateTime.now()
            .add(kSeatHoldWhileSelecting)
            .millisecondsSinceEpoch,
      });
    } on FirebaseException catch (e) {
      if (e.code == 'permission-denied') {
        throw const BusinessException(
          'Ghế này vừa có người khác giữ.',
          code: 'seat-taken',
        );
      }
      throw ServerException('RTDB: ${e.code}');
    }
  }

  @override
  Future<void> unlockSeat(String eventId, String seatCode) async {
    try {
      await _seatRef(eventId, seatCode).remove();
    } on FirebaseException catch (e) {
      if (e.code != 'permission-denied') {
        throw ServerException('RTDB: ${e.code}');
      }
    }
  }
}
