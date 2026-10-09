import 'package:event_horizon/features/booking/data/models/seat_map_mappers.dart';
import 'package:flutter_test/flutter_test.dart';

Map<String, dynamic> _floor({
  int rows = 2,
  int cols = 3,
  String cells = 'V.SS.S',
  Map<String, String> legend = const {'V': 't2', 'S': 't1'},
}) => {
  'floors': [
    {
      'name': 'Tầng 1',
      'rows': rows,
      'cols': cols,
      'cells': cells,
      'legend': legend,
    },
  ],
};

void main() {
  test('mã ghế theo hàng-chữ cột-số, lối đi có ticketTypeId null', () {
    final cells = mapSeatMapFloors(_floor()).first.cells;
    expect(cells, hasLength(6));
    expect(cells[0].code, '1-A1');
    expect(cells[0].ticketTypeId, 't2');
    expect(cells[1].isSeat, isFalse);
    expect(cells[3].code, '1-B1');
    expect(cells[3].ticketTypeId, 't1');
  });

  test('ký tự không có legend -> coi là lối đi', () {
    final cells = mapSeatMapFloors(_floor(cells: 'VXSS.S')).first.cells;
    expect(cells[1].isSeat, isFalse);
  });

  test('cells ngắn hơn rows*cols -> coi là lối đi, không nổ', () {
    final cells = mapSeatMapFloors(_floor(cells: 'VS')).single.cells;
    expect(cells, hasLength(6));
    expect(cells[0].isSeat, isTrue);
    expect(cells[5].isSeat, isFalse);
  });

  test('không có floors -> danh sách rỗng', () {
    expect(mapSeatMapFloors(const {}), isEmpty);
  });
}
