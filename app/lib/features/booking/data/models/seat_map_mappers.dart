import '../../domain/entities/seat_map.dart';

List<SeatMapFloor> mapSeatMapFloors(Map<String, dynamic> data) {
  final rawFloors = (data['floors'] as List?) ?? const [];
  final floors = <SeatMapFloor>[];
  for (var f = 0; f < rawFloors.length; f++) {
    final raw = Map<String, dynamic>.from(rawFloors[f] as Map);
    final rows = (raw['rows'] as num?)?.toInt() ?? 0;
    final cols = (raw['cols'] as num?)?.toInt() ?? 0;
    final cellsStr = raw['cells'] as String? ?? '';
    final legend = Map<String, String>.from(raw['legend'] as Map? ?? {});
    final cells = <SeatCell>[
      for (var r = 0; r < rows; r++)
        for (var c = 0; c < cols; c++)
          SeatCell(
            code: '${f + 1}-${String.fromCharCode(65 + r)}${c + 1}',
            row: r,
            col: c,
            ticketTypeId: r * cols + c < cellsStr.length
                ? legend[cellsStr[r * cols + c]]
                : null,
          ),
    ];
    floors.add(
      SeatMapFloor(
        name: (raw['name'] as String?) ?? 'Tầng ${f + 1}',
        rows: rows,
        cols: cols,
        cells: cells,
      ),
    );
  }
  return floors;
}
