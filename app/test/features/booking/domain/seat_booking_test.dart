import 'package:event_horizon/features/booking/data/models/seat_map_mappers.dart';
import 'package:event_horizon/features/booking/domain/entities/seat_booking.dart';
import 'package:flutter_test/flutter_test.dart';

final _floors = mapSeatMapFloors({
  'floors': [
    {
      'name': 'Tầng 1',
      'rows': 2,
      'cols': 3,
      'cells': 'V.SS.V',
      'legend': {'V': 't2', 'S': 't1'},
    },
  ],
});

void main() {
  test('gom ghế: mỗi loại vé MỘT dòng, quantity đúng bằng số ghế', () {
    final items = groupSeatsIntoItems(_floors, {'1-A1', '1-A3', '1-B3'});
    items.sort((a, b) => a.ticketTypeId.compareTo(b.ticketTypeId));

    expect(items, hasLength(2));
    expect(items[0].ticketTypeId, 't1');
    expect(items[0].quantity, 1);
    expect(items[0].seatCodes, ['1-A3']);
    expect(items[1].ticketTypeId, 't2');
    expect(items[1].quantity, 2);
    expect(items[1].seatCodes..sort(), ['1-A1', '1-B3']);
  });

  test('mọi dòng đều có quantity == số ghế (luật server)', () {
    for (final item in groupSeatsIntoItems(_floors, {
      '1-A1',
      '1-A3',
      '1-B1',
      '1-B3',
    })) {
      expect(item.quantity, item.seatCodes.length, reason: item.ticketTypeId);
    }
  });

  test('ghế lạ (không có trong sơ đồ) bị bỏ, không tạo dòng rác', () {
    final items = groupSeatsIntoItems(_floors, {'1-A1', '9-Z9'});
    expect(items, hasLength(1));
    expect(items.single.seatCodes, ['1-A1']);
  });

  test('chưa chọn ghế nào -> không có dòng nào', () {
    final items = groupSeatsIntoItems(_floors, {});
    expect(items, isEmpty);
  });

  test('tổng tiền cộng theo hạng của từng ghế', () {
    final priceByType = {'t1': 2000, 't2': 0500};
    expect(seatsTotalAmount(_floors, {'1-A1', '1-A3'}, priceByType), 7000);
  });

  test('loại vé không có giá -> tính 0, không nổ', () {
    expect(seatsTotalAmount(_floors, {'1-A1'}, const {}), 0);
  });
}
