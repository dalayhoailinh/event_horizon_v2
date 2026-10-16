import 'package:flutter/material.dart';

import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../domain/entities/seat_map.dart';

/// One floor of the seat map: a "Sân khấu" bar on top, then the grid. Scrolls
/// sideways when the floor is wider than the screen instead of overflowing.
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

  static const double cellSize = 24.0;
  static const double gap = 5;

  SeatCell _at(int row, int col) => floor.cells[row * floor.cols + col];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final gridWidth = floor.cols * (cellSize + gap);
    return Center(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: gridWidth,
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.smd),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
              child: Text(
                'Sân khấu',
                style: theme.textTheme.titleSmall?.copyWith(
                  color: theme.colorScheme.onPrimaryContainer,
                ),
              ),
            ),
            AppSpacing.vLg,
            for (var r = 0; r < floor.rows; r++)
              Padding(
                padding: const EdgeInsets.only(bottom: gap),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    for (var c = 0; c < floor.cols; c++)
                      _SeatBox(
                        cell: _at(r, c),
                        color: colorOf(context, _at(r, c)),
                        onTap: onTap?.call(_at(r, c)),
                      ),
                  ],
                ),
              ),
          ],
        ),
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
        width: SeatMapView.cellSize + SeatMapView.gap,
        height: SeatMapView.cellSize,
      );
    }
    return Padding(
      padding: const EdgeInsets.only(right: SeatMapView.gap),
      child: Tooltip(
        message: cell.code,
        child: MouseRegion(
          cursor: onTap == null
              ? SystemMouseCursors.forbidden
              : SystemMouseCursors.click,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(AppRadius.xs),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              width: SeatMapView.cellSize,
              height: SeatMapView.cellSize,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(AppRadius.xs),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
