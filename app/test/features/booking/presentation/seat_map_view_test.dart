import 'package:event_horizon/features/booking/data/models/seat_map_mappers.dart';
import 'package:event_horizon/features/booking/presentation/widgets/seat_map_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Map<String, dynamic> _seededMap() {
  final buffer = StringBuffer();
  for (var r = 0; r < 8; r++) {
    for (var c = 0; c < 12; c++) {
      buffer.write(c == 6 ? '.' : (r < 2 ? 'V' : 'S'));
    }
  }
  return {
    'floors': [
      {
        'name': 'Floor 1',
        'rows': 8,
        'cols': 12,
        'cells': buffer.toString(),
        'legend': {'V': 't2', 'S': 't1'},
      },
    ],
  };
}

void main() {
  testWidgets('lưới 8×12 vẽ đủ 88 ghế, không tràn khung điện thoại', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(375, 812);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    final floor = mapSeatMapFloors(_seededMap()).single;
    expect(floor.seatCount, 88);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SeatMapView(
            floor: floor,
            colorOf: (context, cell) => Colors.blue,
          ),
        ),
      ),
    );
    await tester.pump();

    // Tràn khung là lỗi Flutter ném ra lúc build; không có nghĩa là vừa khít.
    expect(tester.takeException(), isNull);
    expect(find.byType(Tooltip), findsNWidgets(88));
  });
}
