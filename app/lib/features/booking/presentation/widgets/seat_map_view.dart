import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../domain/entities/seat_map.dart';

class SeatMapView extends StatelessWidget {
  final SeatMapFloor floor;
  final Color Function(BuildContext context, SeatCell cell) colorOf;
  final VoidCallback? Function(SeatCell cell)? onTap;

  const SeatMapView({
    super.key,
    required this.floor,
    required this.colorOf,
    this.onTap,
  });

  static const double _cellSize = 22.0;
  static const double _gap = 4;

  SeatCell _at(int row, int col) => floor.cells[row * floor.cols + col];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var r = 0; r < floor.rows; r++)
            Padding(
              padding: const EdgeInsets.only(bottom: _gap),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (var c = 0; c < floor.cols; c++)
                    _SeatBox(
                      cell: floor.cells[r * floor.cols + c],
                      color: colorOf(context, floor.cells[r * floor.cols + c]),
                      onTap: onTap?.call(_at(r, c)),
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _SeatBox extends StatelessWidget {
  final SeatCell cell;
  final Color color;
  final VoidCallback? onTap;

  const _SeatBox({required this.cell, required this.color, this.onTap});

  @override
  Widget build(BuildContext context) {
    if (!cell.isSeat) {
      return const SizedBox(
        width: SeatMapView._cellSize + SeatMapView._gap,
        height: SeatMapView._cellSize,
      );
    }
    return Padding(
      padding: const EdgeInsets.only(right: SeatMapView._gap),
      child: Tooltip(
        message: cell.code,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppSpacing.xs),
          child: Container(
            width: SeatMapView._cellSize,
            height: SeatMapView._cellSize,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(AppSpacing.xs),
            ),
          ),
        ),
      ),
    );
  }
}
