import 'booking_item_input.dart';
import 'seat_map.dart';

Map<String, String> ticketTypeBySeat(List<SeatMapFloor> floors) => {
  for (final floor in floors)
    for (final cell in floor.cells) cell.code: ?cell.ticketTypeId,
};

List<BookingItemInput> groupSeatsIntoItems(
  List<SeatMapFloor> floors,
  Set<String> selectedSeats,
) {
  final typeBySeat = ticketTypeBySeat(floors);
  final seatsByType = <String, List<String>>{};
  for (final code in selectedSeats) {
    final typeId = typeBySeat[code];
    if (typeId == null) continue;
    seatsByType.putIfAbsent(typeId, () => []).add(code);
  }
  return seatsByType.entries
      .map(
        (e) => BookingItemInput(
          ticketTypeId: e.key,
          quantity: e.value.length,
          seatCodes: e.value,
        ),
      )
      .toList();
}

int seatsTotalAmount(
  List<SeatMapFloor> floors,
  Set<String> selectedSeats,
  Map<String, int> priceByType,
) {
  final typeBySeat = ticketTypeBySeat(floors);
  var total = 0;
  for (final code in selectedSeats) {
    total += priceByType[typeBySeat[code]] ?? 0;
  }
  return total;
}
