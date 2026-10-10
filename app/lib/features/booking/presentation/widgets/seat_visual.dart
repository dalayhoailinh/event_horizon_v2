import '../../domain/entities/seat_lock.dart';
import '../../domain/entities/seat_map.dart';

enum SeatVisual { aisle, free, mine, heldByOther, sold }

SeatVisual seatVisualFor({
  required SeatCell cell,
  required SeatLock? lock,
  required bool selectedByMe,
  required DateTime now,
}) {
  if (!cell.isSeat) return SeatVisual.aisle;
  if (selectedByMe) return SeatVisual.mine;
  if (lock == null) return SeatVisual.free;
  if (lock.isSold) return SeatVisual.sold;
  if (lock.isExpired(now)) return SeatVisual.free;
  return SeatVisual.heldByOther;
}
