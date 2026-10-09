class SeatCell {
  final String code;
  final int row;
  final int col;

  final String? ticketTypeId;

  const SeatCell({
    required this.code,
    required this.row,
    required this.col,
    this.ticketTypeId,
  });

  bool get isSeat => ticketTypeId != null;
}

class SeatMapFloor {
  final String name;
  final int rows;
  final int cols;

  final List<SeatCell> cells;

  const SeatMapFloor({
    required this.name,
    required this.rows,
    required this.cols,
    required this.cells,
  });

  int get seatCount => cells.where((cell) => cell.isSeat).length;
}
