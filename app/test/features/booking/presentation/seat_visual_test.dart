import 'package:event_horizon/features/booking/domain/entities/seat_lock.dart';
import 'package:event_horizon/features/booking/domain/entities/seat_map.dart';
import 'package:event_horizon/features/booking/presentation/widgets/seat_visual.dart';
import 'package:flutter_test/flutter_test.dart';

final _now = DateTime.now();

const _seat = SeatCell(code: '1-A1', row: 0, col: 0, ticketTypeId: 't1');
const _aisle = SeatCell(code: '1-A2', row: 0, col: 1);

SeatLock _lock({String status = 'selecting', Duration? left}) => SeatLock(
  seatCode: '1-A1',
  userId: 'other',
  status: status,
  expiresAt: left == null ? null : _now.add(left).millisecondsSinceEpoch,
);

void main() {
  test('lối đi thì không phải ghế', () {
    expect(
      seatVisualFor(cell: _aisle, lock: null, now: _now),
      SeatVisual.aisle,
    );
  });

  test('không ai giữ', () {
    expect(seatVisualFor(cell: _seat, lock: null, now: _now), SeatVisual.free);
  });

  test('người khác giữ, còn hạn -> đang giữ', () {
    expect(
      seatVisualFor(
        cell: _seat,
        lock: _lock(left: const Duration(seconds: 30)),
        now: _now,
      ),
      SeatVisual.heldByOther,
    );
  });

  test('khóa ĐÃ HẾT HẠN -> vẽ là trống, vì rules cho chiếm lại', () {
    expect(
      seatVisualFor(
        cell: _seat,
        lock: _lock(left: const Duration(seconds: -30)),
        now: _now,
      ),
      SeatVisual.free,
    );
  });

  test('đã bán thì hết hạn hay không cũng vẫn là đã bán', () {
    expect(
      seatVisualFor(
        cell: _seat,
        lock: _lock(status: 'sold', left: const Duration(seconds: -30)),
        now: _now,
      ),
      SeatVisual.sold,
    );
  });
}
